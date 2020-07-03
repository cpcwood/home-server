require 'spec_helper'

describe 'Views' do
  describe 'password/reset rendering' do
    it 'Displays username' do
      assign(:user, @test_user)

      render template: 'password/reset_password.html.erb'

      expect(rendered).to match(Regexp.escape("User: #{@test_user.username}"))
    end
  end
end