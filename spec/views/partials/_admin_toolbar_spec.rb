describe 'Views' do
  let(:user) { create(:user) }
  let(:singular) { build_stubbed(:about) }
  let(:collection) do
    create(:post, user: user)
    create(:post, user: user)
    Post.all
  end

  describe 'admin toolbar rendering' do
    context('user unassigned') do
      it 'no render' do
        render partial: 'partials/admin_toolbar.html.erb', locals: { model: singular }
        expect(rendered).not_to match('toolbar-container')
      end
    end

    context('user assigned') do
      before(:each) do
        assign(:user, user)
        allow_any_instance_of(AdminLinkHelper).to receive(:current_path).and_return('/admin/test')
      end

      context 'admin scope' do
        it 'singular model' do
          render partial: 'partials/admin_toolbar.html.erb', locals: { model: singular }
          expect(rendered).to match('View Section')
          expect(rendered).not_to match('Create New')
        end

        it 'collection' do
          render partial: 'partials/admin_toolbar.html.erb', locals: { model: collection }
          expect(rendered).to match('View Section')
          expect(rendered).to match('Create New')
        end
      end

      context 'public scope' do
        before(:each) do
          allow_any_instance_of(AdminLinkHelper).to receive(:current_path).and_return('/test')
        end

        it 'renders buttons' do
          render partial: 'partials/admin_toolbar.html.erb', locals: { model: singular }
          expect(rendered).not_to match('View Section')
          expect(rendered).not_to match('Create New')
          expect(rendered).to match('Admin Edit')
        end
      end
    end
  end
end