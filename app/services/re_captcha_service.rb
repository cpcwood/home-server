require 'faraday'
require 'json'

module ReCaptchaService
  mattr_accessor :logger

  class << self
    def enabled?
      !Rails.env.development?
    end

    def recaptcha_valid?(client_response)
      return true unless enabled?
      response = Faraday.post('https://www.google.com/recaptcha/api/siteverify') do |request|
        request.params['secret'] = Rails.configuration.grecaptcha_site_secret
        request.params['response'] = client_response
      end
      JSON.parse(response.body)['success'] == true
    end
  end
end