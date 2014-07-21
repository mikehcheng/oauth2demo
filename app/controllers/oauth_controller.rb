class OauthController < ApplicationController
  before_action :saml_authenticate, only: [:index]

  def index
    logger.info 'INDEX'
  end

  private
    def authenticate
      @user = User.find(1)
    end

    def saml_authenticate
      redirect_to saml_login_url
    end
end
