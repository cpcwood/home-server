describe 'Views' do
  let(:site_setting) { build_stubbed(:site_setting) }

  describe 'admin/site_settings rendering' do
    it 'Displays current site name' do
      assign(:site_settings, site_setting)

      render template: 'admin/site_settings/index'

      expect(rendered).to match('Site name')
      expect(rendered).to match(Regexp.escape(site_setting.name))

      expect(rendered).to match('Homepage header')
      expect(rendered).to match(Regexp.escape(site_setting.header_text))

      expect(rendered).to match('Homepage subtitle')
      expect(rendered).to match(Regexp.escape(site_setting.subtitle_text))

      expect(rendered).to match('Enable typed header')
    end
  end
end