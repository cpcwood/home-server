describe 'Views' do
  let(:user) { User.create(username: 'admin', email: 'admin@example.com', password: 'Securepass1', mobile_number: '+447123456789') }

  describe 'admins/analytics rendering' do
    it 'Displays website hits analytics' do
      # Placeholder spec
      assign(:user, user)

      render template: 'admins/analytics.html.erb'

      expect(rendered).to match(/Website hits/)
    end
  end
end