describe 'Views' do
  let(:user) { build_stubbed(:user) }
  let(:post1) { build_stubbed(:post, user: user) }
  let(:post2) { build_stubbed(:post, user: user) }
  let(:posts) { [post1, post2] }

  describe '/admin/blog rendering' do
    context 'index view' do
      before(:each) do
        assign(:posts, posts)
        assign(:user, user)
        render template: '/admin/posts/index.html.erb'
      end

      it 'it renders posts' do
        expect(rendered).to match(post1.title)
        expect(rendered).to match(post2.title)
        expect(rendered).to match(post1.overview)
        expect(rendered).to match(post2.overview)
        expect(rendered).to match(post1.date_published)
        expect(rendered).to match(post1.date_published)
      end

      it 'renders admin toolbar' do
        expect(rendered).to match('toolbar-container')
        expect(rendered).to match('View Section')
        expect(rendered).to match('Create New')
      end
    end
  end
end