class OauthController < ApplicationController
  before_action :authenticate

  def index
    logger.info 'test'
  end

  private
    def authenticate
      @user = User.find(1)
    end
end
