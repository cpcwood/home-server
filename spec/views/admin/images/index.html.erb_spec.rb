require 'spec_helper'

describe 'Views' do
  describe 'admin/site_settings rendering' do
    it 'Displays current site name' do
      assign(:images, @site_settings.images)

      render template: 'admin/images/index.html.erb'

      expect(rendered).to match('Header image')
      expect(rendered).to match('Current image:')
      expect(rendered).to match(Regexp.escape(@site_settings.images.first.name))
    end
  end
end