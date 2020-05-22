require 'spec_helper'

describe 'Rendering admin general section' do
  it 'Displays new contact emails' do
    # Placeholder spec
    assign(:user, @test_user)

    render template: 'admin/notifications.html.erb'

    expect(rendered).to match(/Contact Emails/)
  end

  it 'Displays new contact emails' do
    # Placeholder spec
    assign(:user, @test_user)

    render template: 'admin/notifications.html.erb'

    expect(rendered).to match(/Blog Comments/)
  end
end