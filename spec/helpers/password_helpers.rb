def submit_forgotten_password(email:, captcha_success:)
  stub_request(:post, "https://www.google.com/recaptcha/api/siteverify?response=#{captcha_success}&secret=test")
    .to_return(status: 200, body: "{\"success\": #{captcha_success}}", headers: {})
  post '/forgotten-password', params: { email: email, 'g-recaptcha-response' => captcha_success }
end