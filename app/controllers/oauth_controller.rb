class OauthController < ApplicationController
  EXPIRATION_WINDOW = 1.day

  def token
    expires_now
    case params[:grant_type]
    when 'assertion'
      saml_response = OneLogin::RubySaml::Response.new(params[:assertion])
      saml_response.settings = saml_settings
      if saml_response.isValid?
        token = OauthToken.new(:access_token => generate_token_string,
                               :refresh_token => generate_token_string,
                               :user_attributes => saml_response.attributes.to_json)
        token.save
        logger.info "token: valid saml, token saved"
        render json: {:access_token  => token.access_token,
                      :token_type    => :bearer,
                      :refresh_token => token.refresh_token,
                      :expires_in    => EXPIRATION_WINDOW}
      else
        #invalid saml, save should always be ok
        logger.info "token: invalid saml, no token generated"
        render json: {:error => :invalid_grant,
                      :error_description => "Invalid SAML assertion"}, status: 400
      end
    when 'refresh_token'
      if token = OauthToken.find_by_refresh_token(param['refresh_token'])
        token.access_token = generate_token_string
        token.save
        logger.info "token: valid refresh token, token saved"
        render json: {:access_token  => token.access_token,
                      :token_type    => :bearer,
                      :refresh_token => token.refresh_token,
                      :expires_in    => EXPIRATION_WINDOW}
      else
        #invalid refresh token
        logger.info "token: unable to find refresh token"
        render json: {:error => :invalid_grant,
                      :error_description => "Invalid refresh token"}, status: 400
      end
    else
      logger.info "token: unsupported grant type"
      render json: {:error => :unsupported_grant_type}, status: 400
    end
  end

  def verify
    expires_now
    if token = OauthToken.find_by_access_token(params[:token])
      logger.info "verify: access token is good"
      render json: token.user_attributes
    end
      #unable to find access token
      logger.info "verify: invalid access token"
      #if thru authentication, must error 401,
      #as I understand it, this is posted from main app as json,
      #and main app should respond with 401
      render json: {:error => :invalid_client,
                    :error_description => "Invalid access token"}, status: 400
    end
  end

  private
    def generate_token_string
      SecureRandom.urlsafe_base64(16)
    end
end
