describe 'Views' do
  let(:user) { build_stubbed(:user) }

  describe 'admin/users/:id/edit rendering' do
    it 'Displays current user details' do
      assign(:user, user)

      render template: 'admin/users/edit'

      expect(rendered).to match(Regexp.escape("Username</strong> #{user.username}"))
      expect(rendered).to match(Regexp.escape("Email Address</strong> #{user.email}"))
    end
  end
end