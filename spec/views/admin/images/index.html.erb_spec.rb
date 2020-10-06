require 'spec_helper'

describe 'Views' do
  describe 'admin/images rendering' do
    it 'Displays current site name' do
      site_images = ([@site_settings.header_image] + @site_settings.cover_images)
      assign(:images, site_images)

      render template: 'admin/images/index.html.erb'

      expect(rendered).to match('Header image')
      expect(rendered).to match('Current image:')
      expect(rendered).to match(Regexp.escape(site_images.first.description))
    end
  end
end