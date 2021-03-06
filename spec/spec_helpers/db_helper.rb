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
  @blog_post = create(:post, user: @user) do |post|
    @blog_post_section = create(:post_section, post: post)
  end
end

def seed_gallery_image
  @gallery_image = create(:gallery_image, user: @user)
end

def seed_code_snippet
  @code_snippet = create(:code_snippet, user: @user)
end

def seed_project
  @project = create(:project)
end

def seed_user_and_settings
  seed_user
  seed_site_settings
  seed_about
end