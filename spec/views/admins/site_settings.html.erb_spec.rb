require 'spec_helper'

describe 'Views' do
  describe 'admins/site_settings rendering' do
    it 'Displays current site name' do
      assign(:site_settings, @site_settings)

      render template: 'admins/site_settings.html.erb'

      expect(rendered).to match('Current site name:')
      expect(rendered).to match(Regexp.escape(@site_settings.name))
    end
  end
end