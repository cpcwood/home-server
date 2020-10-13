describe 'Views' do
  let(:user) { create(:user) }

  describe 'passwords/reset rendering' do
    it 'Displays username' do
      assign(:user, user)

      render template: 'passwords/reset_password.html.erb'

      expect(rendered).to match(Regexp.escape("User: #{user.username}"))
    end
  end
end