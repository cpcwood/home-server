class PasswordMailer < ApplicationMailer
  rescue_from ActiveJob::DeserializationError do |exception|
    # user deleted before email could be sent
  end

  def password_reset_email; end
end
