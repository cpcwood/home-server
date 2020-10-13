describe 'Views' do
  let(:site_setting) { build_stubbed(:site_setting) }
  let(:site_setting_header_enabled) { build_stubbed(:site_setting, typed_header_enabled: true) }
  let(:header_image) { build_stubbed(:header_image, site_setting: site_setting) }

  describe 'homepages/index rendering' do
    it 'Custom user titles' do
      assign(:site_settings, site_setting)
      assign(:cover_images, [])
      assign(:header_image, header_image)

      render template: 'homepages/index.html.erb', layout: 'layouts/application'

      expect(rendered).to match(Regexp.escape(site_setting.header_text))
      expect(rendered).to match(Regexp.escape(site_setting.subtitle_text))
      expect(rendered).to_not match(/id="typed-strings-header"/)
      expect(rendered).to_not match(/id="typed-strings-subtitle"/)
    end

    it 'Typed header enabled' do
      assign(:site_settings, site_setting_header_enabled)
      assign(:cover_images, [])
      assign(:header_image, header_image)

      render template: 'homepages/index.html.erb', layout: 'layouts/application'
      expect(rendered).to match(/id="typed-strings-header"/)
      expect(rendered).to match(/id="typed-strings-header"/)
    end
  end
end