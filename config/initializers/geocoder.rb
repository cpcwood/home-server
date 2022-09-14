Geocoder.configure(
  ip_lookup: :geoip2,
  geoip2: {
    file: "/var/opt/maxmind/GeoLite2-City.mmdb"
  }
)
