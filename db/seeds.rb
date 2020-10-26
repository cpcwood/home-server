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

HeaderImage.create(
  site_setting: site_settings,
  description: 'Header image')

CoverImage.create(
  site_setting: site_settings,
  link: '/about',
  description: 'ABOUT')

CoverImage.create(
  site_setting: site_settings,
  link: '/projects',
  description: 'PROJECTS')

CoverImage.create(
  site_setting: site_settings,
  link: '/blog',
  description: 'BLOG')

CoverImage.create(
  site_setting: site_settings,
  link: '/say-hello',
  description: 'SAY HELLO')

CoverImage.create(
  site_setting: site_settings,
  link: '/gallery',
  description: 'GALLERY')

CoverImage.create(
  site_setting: site_settings,
  link: '/contact',
  description: 'CONTACT')


About.create(section_title: 'About me',
             name: 'admin',
             location: 'London, UK',
             contact_email: 'admin@example.com')