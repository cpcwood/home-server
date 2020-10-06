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

about = About.create(name: 'owners name')

# header images
#=============
header_image_x_dim = 2560
header_image_y_dim = 300
#=============

HeaderImage.create(
  site_setting: site_settings,
  x_dim: header_image_x_dim,
  y_dim: header_image_y_dim,
  description: 'Header image')

# cover images
#=============
cover_image_x_dim = 1450
cover_image_y_dim = 680
#=============

CoverImage.create(
  site_setting: site_settings,
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim,
  link: '/about',
  description: 'ABOUT')

CoverImage.create(
  site_setting: site_settings,
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim,
  link: '/projects',
  description: 'PROJECTS')

CoverImage.create(
  site_setting: site_settings,
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim,
  link: '/blog',
  description: 'BLOG')

CoverImage.create(
  site_setting: site_settings,
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim,
  link: '/say-hello',
  description: 'SAY HELLO')

CoverImage.create(
  site_setting: site_settings,
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim,
  link: '/gallery',
  description: 'GALLERY')

CoverImage.create(
  site_setting: site_settings,
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim,
  link: '/contact',
  description: 'CONTACT')


CoverImage.create(
  site_setting: site_settings,
  x_dim: cover_image_x_dim,
  y_dim: cover_image_y_dim,
  link: '/contact',
  description: 'CONTACT')

# profile images
#=============
profile_image_x_dim = 680
profile_image_y_dim = 680
#=============

ProfileImage.create(
  about: about,
  x_dim: profile_image_x_dim,
  y_dim: profile_image_y_dim,
  description: 'about me profile image')