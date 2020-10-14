describe 'Views' do
  let(:user) { create(:user) }

  describe 'admin toolbar rendering' do
    it 'user assigned (logged in)' do
      assign(:user, user)

      render partial: 'partials/admin_toolbar.html.erb'

      expect(rendered).to match('toolbar-container')
    end

    it 'user unassigned (logged out)' do
      render partial: 'partials/admin_toolbar.html.erb'

      expect(rendered).not_to match('toolbar-container')
    end
  end
end