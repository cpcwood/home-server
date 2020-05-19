# Preview all emails at http://localhost:3000/rails/mailers/password_mailer
class PasswordMailerPreview < ActionMailer::Preview
  def password_reset_email
    @user = User.find_by(username: 'admin')
    PasswordMailer.with(user: @user).password_reset_email
  end

  def password_updated
    @user = User.find_by(username: 'admin')
    PasswordMailer.with(user: @user).password_updated_email
  end
end
