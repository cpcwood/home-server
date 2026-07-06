describe 'Views' do
  let(:user) { build_stubbed(:user) }
  let(:contact_messages) do
    [
      build_stubbed(:contact_message, subject: 'First enquiry'),
      build_stubbed(:contact_message, subject: 'Second enquiry')
    ]
  end

  describe 'admins/notifications rendering' do
    it 'Displays contact messages' do
      assign(:user, user)
      assign(:contact_messages, contact_messages)
      assign(:page, 1)
      assign(:more_pages, false)

      render template: 'admins/notifications'

      expect(rendered).to match(/Contact Messages/)
      expect(rendered).to match(/First enquiry/)
      expect(rendered).to match(/Second enquiry/)
    end
  end
end
