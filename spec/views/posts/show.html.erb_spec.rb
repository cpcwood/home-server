describe 'Views' do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:post_section_one) { create(:post_section, post: post, text: 'post section 1') }
  let!(:post_section_two) { create(:post_section, post: post, text: 'post section 2') }

  describe '/blog/:id rendering' do
    it 'show view' do
      assign(:post, post.reload)
      expect_any_instance_of(MarkdownHelper).to receive(:markdown_admin).with(post_section_one.text).and_return("markdown #{post_section_one.text} markdown")
      expect_any_instance_of(MarkdownHelper).to receive(:markdown_admin).with(post_section_two.text).and_return("markdown #{post_section_two.text} markdown")

      render template: 'posts/show'

      expect(rendered).to match(Regexp.escape(post.title))
      expect(rendered).to match(Regexp.escape(user.username))
      expect(rendered).to match(posts_path)
      expect(rendered).to match("markdown #{post_section_one.text} markdown")
      expect(rendered).to match("markdown #{post_section_two.text} markdown")
    end
  end
end