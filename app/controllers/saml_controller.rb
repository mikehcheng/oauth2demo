class SamlController < ApplicationController
  protect_from_forgery except: [:consume]
  
  def init
    redirect_to(OneLogin::RubySaml::Authrequest.new.create(saml_settings))
  end

  #depending on mobile implementation, this method may do nothing
  #not sure whether the callback will be to the application
  def consume
    response          = OneLogin::RubySaml::Response.new(params[:SAMLResponse])
    response.settings = saml_settings
    logger.info response.attributes
    logger.info response.name_id

    if response.is_valid?
      @user = User.find_by_username(response.name_id) || User.new({:username => response.name_id, :password => "Aspera123_"})
      @user.save!
      logger.info 'success'
      render main_index_path
      # redirect_to main_index_path
    else
      logger.info 'failure'
      raise ActionController::RoutingError.new('Invalid SAML Response')
    end
  end

  def metadata
    render xml: OneLogin::RubySaml::Metadata.new.generate(saml_settings)
  end
end
