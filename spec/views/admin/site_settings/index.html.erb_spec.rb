describe 'Views' do
  let(:site_setting) { SiteSetting.create(name: 'test_name', typed_header_enabled: false, header_text: 'test header_text', subtitle_text: 'test subtitle_text') }

  describe 'admin/site_settings rendering' do
    it 'Displays current site name' do
      assign(:site_settings, site_setting)

      render template: 'admin/site_settings/index.html.erb'

      expect(rendered).to match('Current site name')
      expect(rendered).to match(Regexp.escape(site_setting.name))

      expect(rendered).to match('Homepage header')
      expect(rendered).to match(Regexp.escape(site_setting.header_text))

      expect(rendered).to match('Homepage subtitle')
      expect(rendered).to match(Regexp.escape(site_setting.subtitle_text))

      expect(rendered).to match('Enable typed header')
    end
  end
end