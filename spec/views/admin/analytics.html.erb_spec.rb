require 'spec_helper'

describe 'Views' do
  describe 'admins/analytics rendering' do
    it 'Displays website hits analytics' do
      # Placeholder spec
      assign(:user, @test_user)

      render template: 'admins/analytics.html.erb'

      expect(rendered).to match(/Website hits/)
    end
  end
end