require 'spec_helper'

describe 'Views' do
  describe 'admin/general section' do
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

      expect(rendered).to match(Regexp.escape("Username:</strong> #{@test_user.username}"))
      expect(rendered).to match(Regexp.escape("Email Address:</strong> #{@test_user.email}"))
      expect(rendered).to match(Regexp.escape("Mobile Number:</strong> #{@test_user.mobile_number}"))
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
end