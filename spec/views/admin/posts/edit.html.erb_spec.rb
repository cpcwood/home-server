describe 'Views' do
  let!(:post) { create(:post) }
  let!(:post_section_one) { create(:post_section, post: post, text: 'post section 1') }
  let!(:post_section_two) { create(:post_section, post: post, text: 'post section 2') }

  describe '/admin/posts/:id/edit rendering' do
    context 'edit view' do
      before(:each) do
        assign(:post, post.reload)
        render template: '/admin/posts/edit'
      end

      it 'it renders posts' do
        expect(rendered).to match(Regexp.escape(post.title))
        expect(rendered).to match(Regexp.escape(post.overview))
        expect(rendered).to match(Regexp.escape(post_section_one.text))
        expect(rendered).to match(Regexp.escape(post_section_two.text))
        expect(rendered).to match(admin_post_path(post))
        expect(rendered).to match(posts_path)
        expect(rendered).to match('Return')
        expect(rendered).to match('Remove')
      end
    end
  end
end