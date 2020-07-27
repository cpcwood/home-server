require 'spec_helper'

describe 'Views' do
  describe 'homepages/index rendering' do
    it 'Custom user titles' do
      assign(:site_settings, @site_settings)
      assign(:cover_images, [])

      render template: 'homepages/index.html.erb'

      expect(rendered).to match(Regexp.escape(@site_settings.header_text))
      expect(rendered).to match(Regexp.escape(@site_settings.subtitle_text))
      expect(rendered).to_not match(/id="typed-strings-header"/)
      expect(rendered).to_not match(/id="typed-strings-subtitle"/)
    end

    it 'Typed header enabled' do
      @site_settings.update(typed_header_enabled: true)
      assign(:site_settings, @site_settings)
      assign(:cover_images, [])

      render template: 'homepages/index.html.erb'
      expect(rendered).to match(/id="typed-strings-header"/)
      expect(rendered).to match(/id="typed-strings-header"/)
    end
  end
end