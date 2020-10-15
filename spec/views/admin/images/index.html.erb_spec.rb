describe 'Views' do
  let(:site_setting) { build_stubbed(:site_setting_with_images) }

  describe 'admin/images rendering' do
    it 'Displays current site name' do
      site_images = ([site_setting.header_image] + site_setting.cover_images)

      assign(:images, site_images)

      render template: 'admin/images/index.html.erb'

      expect(rendered).to match('Header image')
      expect(rendered).to match('Current image')
      expect(rendered).to match(Regexp.escape(site_images.first.description))
    end
  end
end