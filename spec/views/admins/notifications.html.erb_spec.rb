describe 'Views' do
  let(:user) { build_stubbed(:user) }

  describe 'admins/notifications rendering' do
    it 'Displays new contact emails' do
      # Placeholder spec
      assign(:user, user)

      render template: 'admins/notifications'

      expect(rendered).to match(/Contact Emails/)
    end
  end
end