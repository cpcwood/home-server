describe 'Views' do
  let(:user) { build_stubbed(:user) }

  describe 'admin/users/:id/edit rendering' do
    it 'Displays current user details' do
      assign(:user, user)

      render template: 'admin/users/edit.html.erb'

      expect(rendered).to match(Regexp.escape("Username</strong> #{user.username}"))
      expect(rendered).to match(Regexp.escape("Email Address</strong> #{user.email}"))
      expect(rendered).to match(Regexp.escape("Mobile Number</strong> #{user.mobile_number}"))
    end
  end
end