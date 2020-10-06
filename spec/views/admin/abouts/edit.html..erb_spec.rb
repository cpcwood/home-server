require 'spec_helper'

describe 'Views' do
  describe 'admin/about rendering' do
    it 'Displays current about information' do
      assign(:about, @about)

      render template: 'admin/abouts/edit.html.erb'

      expect(rendered).to match(@about.name)
      expect(rendered).to match(@about.about_me)
    end
  end
end