feature 'blog posts feature', feature: true do
  before(:each) do
    seed_user_and_settings
  end

  context 'public user' do
    scenario 'no blog posts' do
      visit('/')
      click_on('BLOG')
      expect(page).to have_current_path('/blog')
      expect(page).to have_content('There are no posts here...')
    end

    scenario 'view blog post' do
      seed_blog_post
      visit('/blog')
      expect(page).not_to have_button('Admin Edit')
      expect(page).to have_content(@blog_post.title)
      expect(page).to have_content(@blog_post.overview)
      first('.show-blog-post-button').click
      expect(page).to have_content(@blog_post_section.text)
    end
  end

  context 'admin user' do
    before(:each) do
      seed_blog_post
      login_feature
    end

    scenario 'create blog post', js: true do
      visit('/blog')
      click_on('Create New')
      fill_in('post[title]', with: 'post title')
      fill_in('post[overview]', with: 'post overview')

      # fill in first post section
      fill_in('post[post_sections_attributes][0][text]', with: 'post section text content 1')

      # add second post section
      first('.post-editor-toolbar-button.new-section').click
      fill_in('post[post_sections_attributes][1][text]', with: 'post section text content 2')

      # add third post section
      all('.post-editor-toolbar-button.new-section')[1].click
      fill_in('post[post_sections_attributes][2][text]', with: 'post section text content 3')

      # remove second post section
      all('.post-editor-toolbar-button.remove-section')[1].click

      # remove and restore third post section
      all('.post-editor-toolbar-button.remove-section')[1].click
      all('.post-editor-toolbar-button.restore-section')[1].click

      fill_in('post[date_published]', with: DateTime.new(2020, 04, 19, 0, 0, 0))
      first('.input-submit').click
      expect(page).to have_content('Blog post created')
      expect(page).to have_content('post title')
      expect(page).to have_content('April 19th, 2020')
      expect(page).to have_content('post section text content 1')
      expect(page).to have_content('post section text content 3')
      expect(page).not_to have_content('post section text content 2')
      first('.reading-footer .standard-button').click
      expect(page).to have_content('post overview')
    end

    scenario 'update blog post' do
      visit('/blog')
      first('.show-blog-post-button').click
      click_on('Edit')
      expect(page).to have_content(@blog_post_section.text)
      fill_in('post[title]', with: 'new title')
      click_button('Submit')
      expect(page).to have_content('Blog post updated')
      expect(page).to have_content('new title')
    end

    scenario 'delete blog post' do
      visit('/blog')
      first('.show-blog-post-button').click
      click_on('Edit')
      first('.destroy-button').click
      expect(page).to have_content('Blog post removed')
      expect(page).to have_content('There are no posts here...')
    end
  end
end