feature 'admin update blog posts', feature: true do
  before(:each) do
    seed_test_user
  end

  context 'public user' do
    scenario 'no blog posts' do
      visit('/blog')
      expect(page).to have_content('There are no posts here...')
    end

    scenario 'view blog post' do
      seed_blog_post
      visit('/blog')
      expect(page).not_to have_button('Admin Edit')
      expect(page).to have_content(@blog_post.title)
      expect(page).to have_content(@blog_post.overview)
      first('.show-blog-post-button').click
      expect(page).to have_content(@blog_post.text)
    end
  end

  context 'admin user' do
    before(:each) do
      seed_blog_post
      login_feature
    end

    scenario 'create blog post' do
      visit('/blog')
      click_on('Admin Edit')
      click_on('Create New')
      fill_in('post[title]', with: 'post title')
      fill_in('post[overview]', with: 'post overview')
      fill_in('post[text]', with: 'post text content')
      fill_in('post[date_published]', with: DateTime.new(2020, 04, 19, 0, 0, 0))
      click_button('Submit')
      expect(page).to have_content('Blog post created')
      expect(page).to have_content('post title')
      expect(page).to have_content('post overview')
      expect(page).to have_content('April 19th, 2020')
      click_on('View Section')
      expect(page).to have_content('post title')
      expect(page).to have_content('post overview')
      expect(page).to have_content('April 19th, 2020')
    end

    scenario 'update blog post' do
      visit('/blog')
      click_on('Admin Edit')
      first('.show-blog-post-button').click
      expect(page).to have_content(@blog_post.text)
      fill_in('post[title]', with: 'new title')
      click_button('Submit')
      expect(page).to have_content('Blog post updated')
      expect(page).to have_content('new title')
    end

    scenario 'delete blog post' do
      visit('/blog')
      click_on('Admin Edit')
      first('.show-blog-post-button').click
      first('.destroy-blog-post-button').click
      expect(page).to have_content('Blog post removed')
      expect(page).to have_content('There are no posts here...')
    end
  end
end