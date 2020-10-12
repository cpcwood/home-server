require 'spec_helper'

describe ReCaptchaService do
  let(:client_response) { 'client recaptcha response code' }
  let(:post_response_valid) { double(:response, body: '{"success": true}') }
  let(:post_response_invalid) { double(:response, body: '{"success": false}') }

  describe '.recaptcha_valid?' do
    it 'valid client_response' do
      expect(Faraday).to receive(:post).with('https://www.google.com/recaptcha/api/siteverify').and_return(post_response_valid)
      expect(subject.recaptcha_valid?(client_response)).to eq(true)
    end

    it 'invalid client_response' do
      expect(Faraday).to receive(:post).with('https://www.google.com/recaptcha/api/siteverify').and_return(post_response_invalid)
      expect(subject.recaptcha_valid?(client_response)).to eq(false)
    end
  end
end