class PasswordMailer < ApplicationMailer
  default from: Rails.application.credentials.email[:no_reply_email]
  
  def password_reset_email
    @user = params[:user]
    mail(to: @user.email, subject: "Password Reset: #{@user.email}")
  end
end
