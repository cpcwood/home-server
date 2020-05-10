class PasswordMailer < ApplicationMailer
  rescue_from ActiveJob::DeserializationError do |exception|
    # user deleted before email could be sent
  end

  def password_reset_email
    @user = params[:user]
    mail(to: @user.email, subject: "Password Reset: #{@user.email}")
  end
end
