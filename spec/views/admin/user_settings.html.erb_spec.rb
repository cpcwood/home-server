require 'spec_helper'

describe 'Rendering admin user settings section' do
  it 'Displays current user details' do
    assign(:user, @test_user)

    render template: 'admin/general.html.erb'

    expect(rendered).to match(%r{Username:</strong> admin})
    expect(rendered).to match(%r{Email Address:</strong> admin@example.com})
    expect(rendered).to match(%r{Mobile Number:</strong> \+15005550006})
  end
end