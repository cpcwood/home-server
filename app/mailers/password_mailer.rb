class PasswordMailer < ApplicationMailer
  default from: Rails.application.credentials.email[:no_reply_email]

  def password_reset_email
    @user = params[:user]
    mail(to: @user.email, subject: "Password Reset: #{@user.email}")
  end

  def password_updated_email
    @user = params[:user]
    mail(to: @user.email, subject: "Your Password Has Been Updated: #{@user.email}")
  end
end
