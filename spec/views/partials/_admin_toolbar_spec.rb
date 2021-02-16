describe 'Views' do
  let(:user) { create(:user) }
  let(:new_model) { build(:post, user: user) }
  let(:exisiting_singular_resource) { create(:about) }
  let(:exisiting_resources) { create(:post, user: user) }

  describe 'admin toolbar rendering' do
    context('user unassigned') do
      it 'no render' do
        render partial: 'partials/admin_toolbar.html.erb', locals: { model: exisiting_resources }
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
          render partial: 'partials/admin_toolbar.html.erb', locals: { model: exisiting_singular_resource, singular: true }
          expect(rendered).to match('View Section')
        end

        it 'resources' do
          render partial: 'partials/admin_toolbar.html.erb', locals: { model: exisiting_resources }
          expect(rendered).to match('View Section')
        end
      end

      context 'public scope' do
        before(:each) do
          allow_any_instance_of(AdminLinkHelper).to receive(:current_path).and_return('/test')
        end

        it 'new model' do
          render partial: 'partials/admin_toolbar.html.erb', locals: { model: new_model }
          expect(rendered).to match('Create New')
        end

        it 'edit model' do
          render partial: 'partials/admin_toolbar.html.erb', locals: { model: exisiting_resources }
          expect(rendered).to match('Edit')
        end
      end
    end
  end
end