def create_user
  @user_password = 'Securepass1'
  @user = create(:user, password: @user_password)
end

def create_site_settings
  @site_settings = create(:site_setting) do |site_setting|
    @header_image = create(:header_image, site_setting: site_setting)
    @cover_image = create(:cover_image, site_setting: site_setting)
  end
end

def create_about
  @about = create(:about) do |about|
    @profile_image = create(:profile_image, about: about)
  end
end

def seed_db
  create_user
  create_site_settings
  create_about
end