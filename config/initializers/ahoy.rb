class Ahoy::Store < Ahoy::DatabaseStore
  protected
  def visit_model
    ::Visit
  end
  def event_model
    ::Event
  end
end

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = true

Ahoy.mask_ips = true
Ahoy.cookies = false
