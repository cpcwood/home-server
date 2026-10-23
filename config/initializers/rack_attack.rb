Rack::Attack.throttle("requests by ip", limit: 60, period: 1) do |request|
  request.ip
end

# Routes also match a format suffix or trailing slash (/login.json, /2fa/), so compare the bare path
throttle_path = ->(request) { request.path.chomp('/').sub(%r{\.[^/.]+\z}, '') }

Rack::Attack.throttle("auth attempts by ip", limit: 20, period: 60) do |request|
  request.ip if !request.get? && ['/login', '/2fa'].include?(throttle_path.call(request))
end

Rack::Attack.throttle("email sends by ip", limit: 5, period: 600) do |request|
  request.ip if request.post? && ['/forgotten-password', '/contact-messages'].include?(throttle_path.call(request))
end

# Using 503 because it may make attacker think that they have successfully
# DOSed the site. Rack::Attack returns 429 for throttling by default
Rack::Attack.throttled_responder = lambda do |request|
  [503, {}, ["Server Error\n"]]
end
