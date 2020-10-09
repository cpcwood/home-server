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
      client_verify_number = User.find_by(id: session[:two_factor_auth_id])&.mobile_number
      return false unless client_verify_number
      begin
        Twilio::REST::Client.new(Rails.application.credentials.twilio[:account_sid], Rails.application.credentials.twilio[:auth_token])
      rescue StandardError => e
        logger.error(e)
        false
      end
    end
  end
end