require 'twilio-ruby'

module TwoFactorAuthService
  class << self
    def start(session, user)
      session[:two_factor_auth_id] = user.id
      true
    end
  end
end