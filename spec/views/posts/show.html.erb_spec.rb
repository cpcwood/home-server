describe 'Views' do
  let(:user) { build_stubbed(:user) }
  let(:post) { build_stubbed(:post, user: user) }

  describe '/blog/:id rendering' do
    it 'show view' do
      assign(:post, post)
      expect_any_instance_of(MarkdownHelper).to receive(:markdown_admin).with(post.text).and_return('some markdown')

      render template: 'posts/show.html.erb'

      expect(rendered).to match(Regexp.escape(post.title))
      expect(rendered).to match(Regexp.escape(user.username))
      expect(rendered).to match('some markdown')
      expect(rendered).to match(posts_path)
    end
  end
end