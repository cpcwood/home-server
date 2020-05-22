require 'spec_helper'

describe 'Rendering admin general section' do
  it 'Displays Last Login Time' do
    travel_to Time.zone.local(2020, 04, 19, 15, 20, 00)
    @test_user.update(last_login_time: Time.zone.now)
    assign(:user, @test_user)

    render template: 'admin/general.html.erb'

    expect(rendered).to match(/Time and Date: 15:20 19-04-2020/)
  end
end