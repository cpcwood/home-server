require 'spec_helper'

describe 'Views' do
  describe 'homepages/index rendering' do
    it 'Displays user defined titles' do
      assign(:site_settings, @site_settings)
      assign(:cover_images, [])

      render template: 'homepages/index.html.erb'

      expect(rendered).to match(/test header_text/)
      expect(rendered).to match(/test subtitle_text/)
    end
  end
end