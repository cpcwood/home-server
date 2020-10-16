describe 'Views' do
  let(:user) { build_stubbed(:user) }
  let(:post1) { build_stubbed(:post, user: user) }
  let(:post2) { build_stubbed(:post, user: user) }
  let(:posts) { [post1, post2] }

  describe '/posts rendering' do
    it 'index view' do
      assign(:posts, posts)

      render template: 'posts/index.html.erb'

      expect(rendered).to match(post1.title)
      expect(rendered).to match(post2.title)
      expect(rendered).to match(post1.overview)
      expect(rendered).to match(post2.overview)
      expect(rendered).not_to match('toolbar-container')
    end

    it 'user signed in' do
      assign(:posts, posts)
      assign(:user, user)

      render template: 'posts/index.html.erb'
      expect(rendered).to match('toolbar-container')
    end
  end
end