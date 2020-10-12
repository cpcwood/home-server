require 'twilio-ruby'

module TwoFactorAuthService
  mattr_accessor :logger

  class << self
    def start(session, user)
      session[:two_factor_auth_id] = user.id
      true
    end

    def started?(session)
      !!session[:two_factor_auth_id]
    end

    def send_auth_code(session)
      return true if auth_code_sent?(session)
      user_mobile_number = get_user_mobile_number(session)
      return false unless user_mobile_number
      begin
        Twilio::REST::Client
          .new(Rails.application.credentials.twilio[:account_sid], Rails.application.credentials.twilio[:auth_token])
          .verify
          .services(Rails.application.credentials.twilio[:verify_service_sid])
          .verifications
          .create(to: user_mobile_number, channel: 'sms')
        session[:two_factor_auth_code_sent] = true
        true
      rescue StandardError => e
        logger.error(e)
        false
      end
    end

    def verify_auth_code(session, _auth_code)
      return false unless auth_code_sent?(session)
      user_mobile_number = get_user_mobile_number(session)
      return false unless user_mobile_number
    end

    private

    def get_user_mobile_number(session)
      User.find_by(id: session[:two_factor_auth_id])&.mobile_number
    end

    def auth_code_sent?(session)
      session[:two_factor_auth_code_sent] == true
    end
  end
end