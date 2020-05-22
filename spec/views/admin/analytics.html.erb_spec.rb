require 'spec_helper'

describe 'Rendering admin analytics section' do
  it 'Displays website hits analytics' do
    # Placeholder spec
    assign(:user, @test_user)

    render template: 'admin/analytics.html.erb'

    expect(rendered).to match(/Website hits/)
  end
end