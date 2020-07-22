require 'spec_helper'

describe 'Views' do
  describe 'admin/site_settings rendering' do
    it 'Displays current site name' do
      assign(:site_settings, @site_settings)

      render template: 'admin/site_settings/index.html.erb'

      expect(rendered).to match('Current site name:')
      expect(rendered).to match(Regexp.escape(@site_settings.name))
    end
  end
end