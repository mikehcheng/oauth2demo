class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  force_ssl if Rails.env.production?

  NAME_IDENTIFIER_FORMAT_UNSPECIFIED = "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified"
  SAML_IDP_SSO_TARGET_URL = "https://10.0.201.188:9031/idp/SSO.saml2"
  SAML_IDP_CERT_FINGERPRINT = "2CAD895877E0AD9E98E2B19A798E9D2CB11D2537"

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
