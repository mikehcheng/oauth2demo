class OauthController < ApplicationController
  def token
    raise "Incorrect grant type." if params[:grant_type] != 'assertion'

    response = OneLogin::RubySaml::Response.new(params[:assertion])
    response.settings = saml_settings
    if response.isValid?
      #generate token
    else
      #redirect_to error_page
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
      SecureRandom.uuid
    end
end
