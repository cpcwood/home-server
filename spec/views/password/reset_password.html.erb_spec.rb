describe 'Views' do
  let(:user) { User.create(username: 'admin', email: 'admin@example.com', password: 'Securepass1', mobile_number: '+447123456789') }

  describe 'passwords/reset rendering' do
    it 'Displays username' do
      assign(:user, user)

      render template: 'passwords/reset_password.html.erb'

      expect(rendered).to match(Regexp.escape("User: #{user.username}"))
    end
  end
end