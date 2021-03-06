User.create(
  username: ENV['ADMIN_USERNAME'],
  email: ENV['ADMIN_EMAIL'],
  password: ENV['ADMIN_PASSWORD'],
  mobile_number: ENV['ADMIN_MOBILE_NUMBER'])

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
  link: '/code-snippets',
  description: 'CODE SNIPPETS')

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