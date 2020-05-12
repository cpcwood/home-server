require 'spec_helper'

describe 'rendering reset password' do
  it 'displays username' do
    assign(:user, @test_user)

    render template: 'password/reset_password.html.erb'

    expect(rendered).to match(/User: admin/)
  end
end