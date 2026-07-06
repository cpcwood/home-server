# Throttle requests to login to 1 per second per ip
Rack::Attack.throttle("requests by ip", limit: 60, period: 1) do |request|
  request.ip
end

# Slow brute-forcing of the password and TOTP verify steps
Rack::Attack.throttle("auth attempts by ip", limit: 20, period: 60) do |request|
  request.ip if request.post? && ['/login', '/2fa'].include?(request.path)
end

# Using 503 because it may make attacker think that they have successfully
# DOSed the site. Rack::Attack returns 429 for throttling by default
Rack::Attack.throttled_responder = lambda do |request|
  [503, {}, ["Server Error\n"]]
end