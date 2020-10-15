describe ReCaptchaService do
  let(:client_response) { 'client recaptcha response code' }
  let(:post_response_valid) { double(:response, body: '{"success": true}') }
  let(:post_response_invalid) { double(:response, body: '{"success": false}') }

  describe '.recaptcha_valid?' do
    it 'valid client_response' do
      request_stub = stub_request(:post, "https://www.google.com/recaptcha/api/siteverify?response=#{client_response}&secret=#{Rails.application.credentials.recaptcha[:site_secret]}")
                     .to_return(status: 200, body: '{"success": true}', headers: {})
      expect(subject.recaptcha_valid?(client_response)).to eq(true)
      expect(request_stub).to have_been_requested.times(1)
    end

    it 'invalid client_response' do
      expect(Faraday).to receive(:post).with('https://www.google.com/recaptcha/api/siteverify').and_return(post_response_invalid)
      expect(subject.recaptcha_valid?(client_response)).to eq(false)
    end
  end
end