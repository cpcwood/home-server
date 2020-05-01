def password_athenticate_admin(user:, password:, captcha_success:)
  stub_request(:post, "https://www.google.com/recaptcha/api/siteverify?response=#{captcha_success}&secret=test").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'Content-Length'=>'0',
       	  'User-Agent'=>'Faraday v1.0.0'
           }).
         to_return(status: 200, body: "{\"success\": #{captcha_success}}", headers: {})
  post '/login', params: { user: user, password: password, 'g-recaptcha-response' => captcha_success }
end

def block_twilio_verification_requests
  stub_request(:post, "https://verify.twilio.com/v2/Services/VAbe124f2ff38bc35c1de5c4f5f3fb14c8/Verifications").
  with(
    body: {"Channel"=>"sms", "To"=>"+15005550006"},
    headers: {
    'Accept'=>'application/json',
    'Accept-Charset'=>'utf-8',
    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    'Authorization'=>'Basic QUM4NTAzN2NlZDc4OWQwMmQ2ZTJmYzlhMTgzNDEwYmRkYTpkNjJmNDBjMmMxZTU2ZmJiY2U3NjFiODQ1OGFkNDgzOA==',
    'Content-Type'=>'application/x-www-form-urlencoded',
    'User-Agent'=>'twilio-ruby/5.34.0 (ruby/x86_64-darwin19 2.6.5-p114)'
    }).
  to_return(status: 200, body: "", headers: {})
end

def block_twilio_verification_checks
  stub_request(:post, "https://verify.twilio.com/v2/Services/VAbe124f2ff38bc35c1de5c4f5f3fb14c8/VerificationCheck").
         with(
           body: {"Code"=>"1234", "To"=>"+15005550006"},
           headers: {
       	  'Accept'=>'application/json',
       	  'Accept-Charset'=>'utf-8',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'Authorization'=>'Basic QUM4NTAzN2NlZDc4OWQwMmQ2ZTJmYzlhMTgzNDEwYmRkYTpkNjJmNDBjMmMxZTU2ZmJiY2U3NjFiODQ1OGFkNDgzOA==',
       	  'Content-Type'=>'application/x-www-form-urlencoded',
       	  'User-Agent'=>'twilio-ruby/5.34.0 (ruby/x86_64-darwin19 2.6.5-p114)'
           }).
         to_return(status: 200, body: "", headers: {})
end