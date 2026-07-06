module Admin
  class TwoFactorAuthsController < AdminBaseController
    def new
      session[:pending_otp_secret] ||= ROTP::Base32.random
      @pending_otp_secret = session[:pending_otp_secret]
      provisioning_uri = ROTP::TOTP.new(@pending_otp_secret, issuer: ENV.fetch('SITE_HOST', 'home-server')).provisioning_uri(@user.email)
      @qr_code_svg = RQRCode::QRCode.new(provisioning_uri).as_svg(module_size: 4, viewbox: true)
      render layout: 'layouts/admin_dashboard'
    end

    def create
      pending_secret = session[:pending_otp_secret]
      return redirect_to(new_admin_two_factor_auth_path, alert: 'Two factor setup expired, scan again') unless pending_secret
      return redirect_to(new_admin_two_factor_auth_path, alert: 'Current password incorrect') unless verify_current_password
      auth_code = params[:auth_code].to_s
      timestamp = ROTP::TOTP.new(pending_secret).verify(auth_code, drift_behind: 1, drift_ahead: 1)
      return redirect_to(new_admin_two_factor_auth_path, alert: 'Code incorrect, please try again') unless timestamp
      @user.update(otp_secret: pending_secret, otp_consumed_timestep: timestamp)
      session.delete(:pending_otp_secret)
      redirect_to(edit_admin_user_path(@user), notice: 'Two factor authentication enabled!')
    end

    private

    def verify_current_password
      @user.authenticate(params.dig(:current_password, :password))
    end
  end
end
