describe 'Views' do
  let(:post) { Post.new }

  describe '/admin/blog rendering' do
    context 'new view' do
      before(:each) do
        assign(:post, post)
        render template: '/admin/posts/new.html.erb'
      end

      it 'it renders posts' do
        expect(rendered).to match("post_title")
        expect(rendered).to match("post_overview")
        expect(rendered).to match('post_text')
        expect(rendered).to match('post_date_published')
        expect(rendered).to match(admin_posts_path(Post.new))
      end
    end
  end
end