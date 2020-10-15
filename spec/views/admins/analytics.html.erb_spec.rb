describe 'Views' do
  let(:user) { build_stubbed(:user) }

  describe 'admins/analytics rendering' do
    it 'Displays website hits analytics' do
      # Placeholder spec
      assign(:user, user)

      render template: 'admins/analytics.html.erb'

      expect(rendered).to match(/Website hits/)
    end
  end
end