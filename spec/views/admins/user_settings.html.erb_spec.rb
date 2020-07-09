require 'spec_helper'

describe 'Views' do
  describe 'admins/user_settings rendering' do
    it 'Displays current user details' do
      assign(:user, @test_user)

      render template: 'admins/user_settings.html.erb'

      expect(rendered).to match(Regexp.escape("Username:</strong> #{@test_user.username}"))
      expect(rendered).to match(Regexp.escape("Email Address:</strong> #{@test_user.email}"))
      expect(rendered).to match(Regexp.escape("Mobile Number:</strong> #{@test_user.mobile_number}"))
    end
  end
end