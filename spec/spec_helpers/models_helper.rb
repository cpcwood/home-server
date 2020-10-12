def create_user
  @test_user_password = 'Securepass1'
  @test_user = User.create(username: 'admin', email: 'admin@example.com', password: @test_user_password, mobile_number: '+447123456789')
end

def create_site_settings
  @site_settings = SiteSetting.create(name: 'test_name', typed_header_enabled: false, header_text: 'test header_text', subtitle_text: 'test subtitle_text')
end

def create_images
  create_site_settings
  @header_image = HeaderImage.create(site_setting: @site_settings, description: 'header_image')
  @cover_image = CoverImage.create(site_setting: @site_settings, description: 'cover_image')
end

def create_about
  @about = About.create(name: 'test name', about_me: 'test about me text')
end

def seed_db
  create_user
  create_images
  create_about
end