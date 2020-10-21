def seed_user
  @user_password = 'Securepass1'
  @user = create(:user, password: @user_password)
end

def seed_site_settings
  @site_settings = create(:site_setting) do |site_setting|
    @header_image = create(:header_image, site_setting: site_setting)
    @cover_image = create(:cover_image, site_setting: site_setting)
  end
end

def seed_about
  @about = create(:about) do |about|
    @profile_image = create(:profile_image, about: about)
  end
end

def seed_blog_post
  @blog_post = create(:post, user: @user)
end

def seed_test_user
  seed_user
  seed_site_settings
end