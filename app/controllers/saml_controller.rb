class SamlController < ApplicationController
  protect_from_forgery except: [:consume]

  NAME_IDENTIFIER_FORMAT_UNSPECIFIED = "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified"
  SAML_IDP_SSO_TARGET_URL = "https://10.0.201.188:9031/idp/SSO.saml2"
  SAML_IDP_CERT_FINGERPRINT = "2CAD895877E0AD9E98E2B19A798E9D2CB11D2537"

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

  private
    def saml_settings
      @saml_settings_object ||= OneLogin::RubySaml::Settings.new.tap do |settings|
        settings.assertion_consumer_service_url = saml_callback_url
        settings.issuer                         = saml_metadata_url
        settings.name_identifier_format         = NAME_IDENTIFIER_FORMAT_UNSPECIFIED
        settings.idp_sso_target_url             = SAML_IDP_SSO_TARGET_URL
        settings.idp_cert_fingerprint           = SAML_IDP_CERT_FINGERPRINT
      end
    end
end
