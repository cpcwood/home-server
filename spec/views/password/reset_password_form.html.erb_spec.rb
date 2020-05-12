require 'spec_helper'

describe 'rendering reset password form' do
  it 'displays username' do
    assign(:user, @test_user)

    render template: 'password/reset_password_form.html.erb'

    expect(rendered).to match(/User: admin/)
  end
end