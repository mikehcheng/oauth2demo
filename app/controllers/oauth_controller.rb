class OauthController < ApplicationController
  before_action :saml_authenticate, only: [:index]

  def index
    logger.info 'INDEX'
  end

  def token

  end

  def verify

  end

  private
    def saml_authenticate
      redirect_to saml_login_url
    end

    def create_token
      SecureRandom.uuid
    end
end
