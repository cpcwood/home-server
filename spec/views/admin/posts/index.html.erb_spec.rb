describe 'Views' do
  let(:user) { build_stubbed(:user) }
  let(:post1) { build_stubbed(:post, user: user) }
  let(:post2) { build_stubbed(:post, user: user) }
  let(:posts) { [post1, post2] }

  describe '/admin/blog rendering' do
    before(:each) do
      allow_any_instance_of(AdminLinkHelper).to receive(:in_admin_scope?).and_return(true)
    end

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
        expect(rendered).to match('toolbar-container')
        expect(rendered).to match(edit_admin_post_path(post1))
        expect(rendered).to match(edit_admin_post_path(post2))
      end

      it 'no posts' do
        assign(:posts, [])
        assign(:user, user)
        render template: 'posts/index.html.erb'
        expect(rendered).to match('There are no posts here...')
      end
    end
  end
end