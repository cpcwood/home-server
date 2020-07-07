User.create(
  username: Rails.application.credentials.site_settings[:admin_username],
  email: Rails.application.credentials.site_settings[:admin_email],
  password: Rails.application.credentials.site_settings[:admin_password],
  mobile_number: Rails.application.credentials.twilio[:dev_number])

SiteSetting.create(
  name: Rails.application.credentials.site_settings[:name])