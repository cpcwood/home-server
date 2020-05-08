class PasswordController < ApplicationController
  def forgotten_password
    render :forgotten_password
  end

  def send_reset_link
    redirect_to(:login, notice: 'If the submitted email is associated with an account, a password reset link will be sent') if recaptcha_confirmation(params['g-recaptcha-response'])
  end

  private

  def recaptcha_confirmation(recaptcha_response)
    response = Faraday.post('https://www.google.com/recaptcha/api/siteverify') do |request|
      request.params['secret'] = Rails.application.credentials.recaptcha[:site_secret]
      request.params['response'] = recaptcha_response
    end
    JSON.parse(response.body)['success'] == true
  end
end
