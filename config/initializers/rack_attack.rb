# Throttle requests to login to 1 per second per ip
Rack::Attack.throttle("requests by ip", limit: 60, period: 1) do |request|
  request.ip
end

# Using 503 because it may make attacker think that they have successfully
# DOSed the site. Rack::Attack returns 429 for throttling by default
Rack::Attack.throttled_response = lambda do |request|
  [ 503, {}, ["Server Error\n"]]
end