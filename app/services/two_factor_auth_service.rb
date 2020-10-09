require 'twilio-ruby'

module TwoFactorAuthService
  class << self
    def start(session, user)
      session[:two_factor_auth_id] = user.id
      true
    end

    def started?(session)
      !!session[:two_factor_auth_id]
    end

    def send_auth_code(session)
      client_verify_number = User.find(session[:two_factor_auth_id]).mobile_number
      return false unless client_verify_number
    end
  end
end