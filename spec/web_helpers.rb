def login
  stub_request(:post, 'https://www.google.com/recaptcha/api/siteverify?response&secret=test')
    .with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Length' => '0',
        'User-Agent' => 'Faraday v1.0.0'
      }
    )
    .to_return(status: 200, body: '{"success": true}', headers: {})
  visit('/login')
  fill_in('user', with: 'admin')
  fill_in('password', with: 'Securepass1')
  click_button('Login')
end