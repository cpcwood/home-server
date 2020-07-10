require 'spec_helpers/feature_helpers'

feature 'Admin update site settings', feature: true, slow: true do
  scenario 'Update site name' do
    login_feature
    visit('admin/site_settings')
    fill_in('site_setting[name]', with: 'new_site_name')
    click_button('Update site settings')
    expect(page).to have_content('Name updated!')
    visit('/')
    expect(page).to have_content('new_site_name')
  end

  scenario 'Update header image' do
    login_feature
    visit('admin/site_settings')
    find('#image_upload_header_image').set(Rails.root.join('spec/files/sample_image.jpg'))
    click_button('Update site settings')
    expect(page).to have_content('Header image updated!')
    visit('/')
    expect(page).to have_css("img[src*='sample_image.jpg']")
  end

  scenario 'Update about image' do
    login_feature
    visit('admin/site_settings')
    find('#image_upload_about_image').set(Rails.root.join('spec/files/sample_image.jpg'))
    click_button('Update site settings')
    expect(page).to have_content('About image updated!')
    visit('/')
    expect(page).to have_css("img[src*='sample_image.jpg']")
  end

  scenario 'Update projects image' do
    login_feature
    visit('admin/site_settings')
    find('#image_upload_projects_image').set(Rails.root.join('spec/files/sample_image.jpg'))
    click_button('Update site settings')
    expect(page).to have_content('Projects image updated!')
    visit('/')
    expect(page).to have_css("img[src*='sample_image.jpg']")
  end

  scenario 'Update blog image' do
    login_feature
    visit('admin/site_settings')
    find('#image_upload_blog_image').set(Rails.root.join('spec/files/sample_image.jpg'))
    click_button('Update site settings')
    expect(page).to have_content('Blog image updated!')
    visit('/')
    expect(page).to have_css("img[src*='sample_image.jpg']")
  end

  scenario 'Update say hello image' do
    login_feature
    visit('admin/site_settings')
    find('#image_upload_say_hello_image').set(Rails.root.join('spec/files/sample_image.jpg'))
    click_button('Update site settings')
    expect(page).to have_content('Say hello image updated!')
    visit('/')
    expect(page).to have_css("img[src*='sample_image.jpg']")
  end

  scenario 'Update gallery image' do
    login_feature
    visit('admin/site_settings')
    find('#image_upload_gallery_image').set(Rails.root.join('spec/files/sample_image.jpg'))
    click_button('Update site settings')
    expect(page).to have_content('Gallery image updated!')
    visit('/')
    expect(page).to have_css("img[src*='sample_image.jpg']")
  end

  scenario 'Update contact image' do
    login_feature
    visit('admin/site_settings')
    find('#image_upload_contact_image').set(Rails.root.join('spec/files/sample_image.jpg'))
    click_button('Update site settings')
    expect(page).to have_content('Contact image updated!')
    visit('/')
    expect(page).to have_css("img[src*='sample_image.jpg']")
  end
end