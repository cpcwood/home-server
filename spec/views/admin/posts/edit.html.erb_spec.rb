describe 'Views' do
  let(:post) { create(:post) }

  describe '/admin/blog rendering' do
    context 'edit view' do
      before(:each) do
        assign(:post, post)
        render template: '/admin/posts/edit.html.erb'
      end

      it 'it renders posts' do
        expect(rendered).to match(Regexp.escape(post.title))
        expect(rendered).to match(Regexp.escape(post.overview))
        expect(rendered).to match(Regexp.escape(post.text))
        expect(rendered).to match(admin_post_path(post))
      end
    end
  end
end