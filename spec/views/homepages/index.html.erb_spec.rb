describe 'Views' do
  let(:site_setting) { SiteSetting.create(name: 'test_name', typed_header_enabled: false, header_text: 'test header_text', subtitle_text: 'test subtitle_text') }

  describe 'homepages/index rendering' do
    it 'Custom user titles' do
      assign(:site_settings, site_setting)
      assign(:cover_images, [])

      render template: 'homepages/index.html.erb'

      expect(rendered).to match(Regexp.escape(site_setting.header_text))
      expect(rendered).to match(Regexp.escape(site_setting.subtitle_text))
      expect(rendered).to_not match(/id="typed-strings-header"/)
      expect(rendered).to_not match(/id="typed-strings-subtitle"/)
    end

    it 'Typed header enabled' do
      site_setting.update(typed_header_enabled: true)
      assign(:site_settings, site_setting)
      assign(:cover_images, [])

      render template: 'homepages/index.html.erb'
      expect(rendered).to match(/id="typed-strings-header"/)
      expect(rendered).to match(/id="typed-strings-header"/)
    end
  end
end