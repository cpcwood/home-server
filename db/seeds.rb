User.create(
  username: Rails.application.credentials.site_settings[:admin_username],
  email: Rails.application.credentials.site_settings[:admin_email],
  password: Rails.application.credentials.site_settings[:admin_password],
  mobile_number: Rails.application.credentials.twilio[:dev_number])

site_settings = SiteSetting.create(
  name: Rails.application.credentials.site_settings[:name])

#=============
header_image_x_dim = 2560
header_image_y_dim = 300
#=============

Image.create(
  site_setting: site_settings,
  name: 'header_image',
  x_dim: header_image_x_dim,
  y_dim: header_image_y_dim
)

#=============
cover_image_x_dim = 1450
cover_image_y_dim = 680
#=============

Image.create(
  site_setting: site_settings,
  name: 'about_image',
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim
)

Image.create(
  site_setting: site_settings,
  name: 'projects_image',
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim
)

Image.create(
  site_setting: site_settings,
  name: 'blog_image',
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim
)

Image.create(
  site_setting: site_settings,
  name: 'say_hello_image',
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim
)

Image.create(
  site_setting: site_settings,
  name: 'gallery_image',
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim
)

Image.create(
  site_setting: site_settings,
  name: 'contact_image',
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim
)