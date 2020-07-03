require 'spec_helper'

describe 'Views' do
  describe 'admin/notifications rendering' do
    it 'Displays new contact emails' do
      # Placeholder spec
      assign(:user, @test_user)

      render template: 'admin/notifications.html.erb'

      expect(rendered).to match(/Contact Emails/)
    end

    it 'Displays new blog comment notifications' do
      # Placeholder spec
      assign(:user, @test_user)

      render template: 'admin/notifications.html.erb'

      expect(rendered).to match(/Blog Comments/)
    end

    it 'Displays new blog comment notifications' do
      # Placeholder spec
      assign(:user, @test_user)

      render template: 'admin/notifications.html.erb'

      expect(rendered).to match(/Blog Comments/)
    end

    it 'Displays new say hello notifications' do
      # Placeholder spec
      assign(:user, @test_user)

      render template: 'admin/notifications.html.erb'

      expect(rendered).to match(/Say Hellos/)
    end
  end
end