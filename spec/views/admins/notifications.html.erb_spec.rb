require 'spec_helper'

describe 'Views' do
  let(:user) { User.create(username: 'admin', email: 'admin@example.com', password: 'Securepass1', mobile_number: '+447123456789') }

  describe 'admins/notifications rendering' do
    it 'Displays new contact emails' do
      # Placeholder spec
      assign(:user, user)

      render template: 'admins/notifications.html.erb'

      expect(rendered).to match(/Contact Emails/)
    end

    it 'Displays new blog comment notifications' do
      # Placeholder spec
      assign(:user, user)

      render template: 'admins/notifications.html.erb'

      expect(rendered).to match(/Blog Comments/)
    end

    it 'Displays new blog comment notifications' do
      # Placeholder spec
      assign(:user, user)

      render template: 'admins/notifications.html.erb'

      expect(rendered).to match(/Blog Comments/)
    end

    it 'Displays new say hello notifications' do
      # Placeholder spec
      assign(:user, user)

      render template: 'admins/notifications.html.erb'

      expect(rendered).to match(/Say Hellos/)
    end
  end
end