describe 'Views' do
  let(:user) { create(:user) }

  describe 'admin toolbar rendering' do
    context('user unassigned') do
      it 'no render' do
        render partial: 'partials/admin_toolbar.html.erb'

        expect(rendered).not_to match('toolbar-container')
      end
    end
    
    context('user assigned') do
      before(:each) do
        assign(:user, user)
      end

      context 'admin scope' do
        before(:each) do
          allow_any_instance_of( AdminLinkHelper ).to receive(:in_admin_scope?).and_return(true) 
          allow_any_instance_of( AdminLinkHelper ).to receive(:current_path).and_return('/admin/test')
        end

        it 'renders buttons' do
          render partial: 'partials/admin_toolbar.html.erb'

          expect(rendered).to match('View Section')
        end

        it 'collection' do
          render partial: 'partials/admin_toolbar.html.erb', locals: {collection: true}
          expect(rendered).to match('View Section')
          expect(rendered).to match('Create New')    
        end
      end

      context 'public scope' do
        before(:each) do
          allow_any_instance_of( AdminLinkHelper ).to receive(:current_path).and_return('/test')
        end

        it 'renders buttons' do
          render partial: 'partials/admin_toolbar.html.erb'

          expect(rendered).to match('Admin Edit')
        end
      end
    end
  end
end