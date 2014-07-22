class OauthController < ApplicationController
  EXPIRATION_WINDOW = 1.day

  def token
    raise "Incorrect grant type." if params[:grant_type] != 'assertion'

    saml_response = OneLogin::RubySaml::Response.new(params[:assertion])
    saml_response.settings = saml_settings
    if saml_response.isValid?
      token = OauthToken.new(:access_token => create_token,
                             :refresh_token => create_token,
                             :user_attributes => saml_response.attributes.to_json)
      token.save
      logger.info "token: valid saml, token saved"
      render json: {:access_token  => token.access_token,
                    :token_type    => "bearer"
                    :refresh_token => token.refresh_token,
                    :expires_in    => EXPIRATION_WINDOW}
    else
      logger.info "token: invalid saml, no token generated"
      raise 'Unable to generate tokens.'
    end
  end

  def verify
    if #token_exists
      #post back attributes
    else
      #redirect_to different_error_page/flash error
    end
  end

  private
    def create_token
      SecureRandom.urlsafe_base64(16)
    end
end
