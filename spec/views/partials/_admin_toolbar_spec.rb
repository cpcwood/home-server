describe 'Views' do
  let(:user) { create(:user) }
  let(:new_model) { build(:post, user: user) }
  let(:exisiting_model) { create(:about) }

  describe 'admin toolbar rendering' do
    context('user unassigned') do
      it 'no render' do
        render partial: 'partials/admin_toolbar.html.erb', locals: { model: exisiting_model }
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
          render partial: 'partials/admin_toolbar.html.erb', locals: { model: exisiting_model }
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
          render partial: 'partials/admin_toolbar.html.erb', locals: { model: exisiting_model }
          expect(rendered).to match('Edit')
        end
      end
    end
  end
end