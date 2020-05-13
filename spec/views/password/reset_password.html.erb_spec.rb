require 'spec_helper'

describe 'Rendering reset password' do
  it 'Displays username' do
    assign(:user, @test_user)

    render template: 'password/reset_password.html.erb'

    expect(rendered).to match(/User: admin/)
  end
end