module TwoFactorAuthService
  require 'twilio-ruby'

  mattr_accessor :logger, :twilio_client

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
        twilio_client
          .verifications
          .create(to: user_mobile_number, channel: 'sms')
        session[:two_factor_auth_code_sent] = true
        true
      rescue StandardError => e
        logger.error(e)
        false
      end
    end

    def auth_code_format_valid?(auth_code)
      auth_code.match?(/^\d{6}$/)
    end

    def auth_code_valid?(session:, auth_code:)
      return false unless auth_code_sent?(session)
      user_mobile_number = get_user_mobile_number(session)
      return false unless user_mobile_number
      begin
        verification_check = twilio_client
                             .verification_checks
                             .create(to: user_mobile_number, code: auth_code)
        verification_check.status == 'approved'
      rescue StandardError => e
        logger.error(e)
        false
      end
    end

    def get_user(session)
      User.find_by(id: session[:two_factor_auth_id])
    end

    private

    def get_user_mobile_number(session)
      get_user(session)&.mobile_number
    end

    def twilio_client
      @twilio_client ||= Twilio::REST::Client
                         .new(Rails.configuration.twilio_account_sid, Rails.configuration.twilio_auth_token)
                         .verify
                         .services(Rails.configuration.twilio_verify_service_sid)
    end

    def auth_code_sent?(session)
      session[:two_factor_auth_code_sent] == true
    end
  end
end