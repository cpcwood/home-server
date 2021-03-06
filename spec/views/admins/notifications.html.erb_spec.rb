describe 'Views' do
  let(:user) { build_stubbed(:user) }

  describe 'admins/notifications rendering' do
    it 'Displays new contact emails' do
      # Placeholder spec
      assign(:user, user)

      render template: 'admins/notifications'

      expect(rendered).to match(/Contact Emails/)
    end

    it 'Displays new blog comment notifications' do
      # Placeholder spec
      assign(:user, user)

      render template: 'admins/notifications'

      expect(rendered).to match(/Blog Comments/)
    end

    it 'Displays new blog comment notifications' do
      # Placeholder spec
      assign(:user, user)

      render template: 'admins/notifications'

      expect(rendered).to match(/Blog Comments/)
    end

    it 'Displays new say hello notifications' do
      # Placeholder spec
      assign(:user, user)

      render template: 'admins/notifications'

      expect(rendered).to match(/Say Hellos/)
    end
  end
end