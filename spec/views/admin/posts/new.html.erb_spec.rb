describe 'Views' do
  let(:post) { build(:post) }

  describe '/admin/posts/new rendering' do
    context 'new view' do
      before(:each) do
        assign(:post, post)
        render template: '/admin/posts/new.html.erb'
      end

      it 'it renders posts' do
        expect(rendered).to match('post_title')
        expect(rendered).to match('post_overview')
        expect(rendered).to match('post_text')
        expect(rendered).to match('post_date_published')
      end
    end
  end
end