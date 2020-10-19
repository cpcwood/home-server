feature 'admin update blog posts', feature: true, slow: true do
  scenario 'create and update blog post' do
    # admin feature
    seed_db
    visit('/blog')
    expect(page).not_to have_button('Admin Edit')
    login_feature
    visit('/blog')
    click_on('Admin Edit')

    # create post
    click_on('Create New')
    fill_in('post[title]', with: 'post title')
    fill_in('post[overview]', with: 'post overview')
    fill_in('post[text]', with: 'post text content')
    blog_publish_date = DateTime.new(2020, 04, 19, 0, 0, 0)
    fill_in('post[date_published]', with: blog_publish_date)
    click_button('Submit')
    expect(page).to have_content('Blog post created')
    expect(page).to have_content('post title')
    expect(page).to have_content('post overview')
    expect(page).to have_content(blog_publish_date.utc)

    # view post
    click_on('View Section')
    expect(page).to have_content('post title')
    expect(page).to have_content('post overview')
    expect(page).to have_content(blog_publish_date.utc)
    # add feature for viewing specific post by css selector.first

    # edit post
    click_on('Admin Edit')
    first('.edit-blog-post-button').click
    expect(page).to have_content('post text content')
    fill_in('post[title]', with: 'new title')
    click_button('Submit')
    expect(page).to have_content('Blog post updated')
    expect(page).to have_content('new title')
    click_on('View Section')
    expect(page).to have_content('new title')

    # destroy post
    click_on('Admin Edit')
    first('.destroy-blog-post-button').click
    expect(page).to have_content('Blog post removed')
    expect(page).not_to have_content('new title')
    click_on('View Section')
    expect(page).not_to have_content('new title')
  end
end