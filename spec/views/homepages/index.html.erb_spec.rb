describe 'Views' do
  let(:site_setting) { create(:site_setting) }
  let(:header_image) { create(:header_image, site_setting: site_setting)}

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
      site_setting.update(typed_header_enabled: true)
      assign(:site_settings, site_setting)
      assign(:cover_images, [])
      assign(:header_image, header_image)

      render template: 'homepages/index.html.erb', layout: 'layouts/application'
      expect(rendered).to match(/id="typed-strings-header"/)
      expect(rendered).to match(/id="typed-strings-header"/)
    end
  end
end