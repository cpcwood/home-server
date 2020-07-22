User.create(
  username: Rails.application.credentials.site[:admin_username],
  email: Rails.application.credentials.site[:admin_email],
  password: Rails.application.credentials.site[:admin_password],
  mobile_number: Rails.application.credentials.twilio[:number])

site_settings = SiteSetting.create(
  name: 'home-server',
  typed_header_enabled: true,
  header_text: 'Welcome to your...',
  subtitle_text: 'home-server')

#=============
header_image_x_dim = 2560
header_image_y_dim = 300
#=============

Image.create(
  site_setting: site_settings,
  name: 'header_image',
  x_dim: header_image_x_dim,
  y_dim: header_image_y_dim,
  image_type: 'header_image')

#=============
cover_image_x_dim = 1450
cover_image_y_dim = 680
#=============

Image.create(
  site_setting: site_settings,
  name: 'about_image',
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim,
  image_type: 'cover_image',
  link: '/about',
  description: 'About')

Image.create(
  site_setting: site_settings,
  name: 'projects_image',
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim,
  image_type: 'cover_image',
  link: '/projects',
  description: 'PROJECTS')

Image.create(
  site_setting: site_settings,
  name: 'blog_image',
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim,
  image_type: 'cover_image',
  link: '/blog',
  description: 'BLOG')

Image.create(
  site_setting: site_settings,
  name: 'say_hello_image',
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim,
  image_type: 'cover_image',
  link: '/say-hello',
  description: 'SAY HELLO')

Image.create(
  site_setting: site_settings,
  name: 'gallery_image',
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim,
  image_type: 'cover_image',
  link: '/gallery',
  description: 'GALLERY')

Image.create(
  site_setting: site_settings,
  name: 'contact_image',
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim,
  image_type: 'cover_image',
  link: '/contact',
  description: 'CONTACT')