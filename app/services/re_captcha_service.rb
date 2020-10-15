require 'faraday'
require 'json'

module ReCaptchaService
  mattr_accessor :logger

  class << self
    def recaptcha_valid?(client_response)
      response = Faraday.post('https://www.google.com/recaptcha/api/siteverify') do |request|
        request.params['secret'] = Rails.application.credentials.recaptcha[:site_secret]
        request.params['response'] = client_response
      end
      JSON.parse(response.body)['success'] == true
    end
  end
end