require 'spec_helper'

describe 'Rendering admin general section' do
  it 'Displays last login time' do
    travel_to Time.zone.local(2020, 04, 19, 15, 20, 00)
    @test_user.update(last_login_time: Time.zone.now)
    assign(:user, @test_user)

    render template: 'admin/general.html.erb'

    expect(rendered).to match(%r{Time and Date:</strong> 15:20 19-04-2020})
  end

  it 'Displays last login ip address' do
    @test_user.update(last_login_ip: '127.0.0.1')
    assign(:user, @test_user)

    render template: 'admin/general.html.erb'

    expect(rendered).to match(%r{IP Address:</strong> 127.0.0.1})
  end

  it 'Displays user details' do
    assign(:user, @test_user)

    render template: 'admin/general.html.erb'

    expect(rendered).to match(%r{Username:</strong> admin})
    expect(rendered).to match(%r{Email Address:</strong> admin@example.com})
    expect(rendered).to match(%r{Mobile Number:</strong> \+15005550006})
  end

  it 'Displays overview of notifications' do
    # Placeholder spec
    assign(:user, @test_user)

    render template: 'admin/general.html.erb'

    expect(rendered).to match(/Notifications/)
  end

  it 'Displays overview of notifications' do
    # Placeholder spec
    assign(:user, @test_user)

    render template: 'admin/general.html.erb'

    expect(rendered).to match(/Analytics/)
  end
end