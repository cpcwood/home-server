# Preview all emails at http://localhost:3000/rails/mailers/password_mailer
class PasswordMailerPreview < ActionMailer::Preview
  def password_reset
    @user = User.create(username: 'test', password: 'password', email: 'test@example.com')
    PasswordMailer.with(user: @user).password_reset_email
  end
end
