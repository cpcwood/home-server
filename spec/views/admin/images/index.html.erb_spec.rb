require 'spec_helper'

describe 'Views' do
  let(:site_setting) { SiteSetting.create(name: 'test_name', typed_header_enabled: false, header_text: 'test header_text', subtitle_text: 'test subtitle_text') }

  describe 'admin/images rendering' do
    it 'Displays current site name' do
      HeaderImage.create(site_setting: site_setting, description: 'header_image')
      CoverImage.create(site_setting: site_setting, description: 'cover_image')
      site_images = ([site_setting.header_image] + site_setting.cover_images)

      assign(:images, site_images)

      render template: 'admin/images/index.html.erb'

      expect(rendered).to match('Header image')
      expect(rendered).to match('Current image')
      expect(rendered).to match(Regexp.escape(site_images.first.description))
    end
  end
end