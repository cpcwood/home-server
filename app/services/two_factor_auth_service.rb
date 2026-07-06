module TwoFactorAuthService
  class << self
    def start(session, user)
      session[:two_factor_auth_id] = user.id
      true
    end

    def started?(session)
      !!session[:two_factor_auth_id]
    end

    def auth_code_format_valid?(auth_code)
      auth_code.match?(/\A\d{6}\z/)
    end

    def auth_code_valid?(session:, auth_code:)
      !!get_user(session)&.verify_totp!(auth_code)
    end

    def get_user(session)
      User.find_by(id: session[:two_factor_auth_id])
    end
  end
end
