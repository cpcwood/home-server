require 'spec_helper'

describe 'Views' do
  let(:about) { About.create(name: 'test name', about_me: 'test about me text') }

  describe 'admin/about rendering' do
    it 'default view' do
      profile_image = ProfileImage.create
      assign(:about, about)

      render template: 'admin/abouts/edit.html.erb'

      expect(rendered).to match(about.name)
      expect(rendered).to match(about.about_me)
      expect(rendered).to match("Images will be resized to #{profile_image.x_dim}")
      expect(rendered).to match(profile_image.y_dim.to_s)
    end

    it 'No image attached' do
      assign(:about, about)

      render template: 'admin/abouts/edit.html.erb'

      expect(rendered).to match('New image')
      expect(rendered).not_to match('Update image')
      expect(rendered).not_to match('Remove image')
    end

    it 'image attached' do
      about.create_profile_image
      assign(:about, about)

      render template: 'admin/abouts/edit.html.erb'

      expect(rendered).to match('Update image')
      expect(rendered).to match('Remove image')
      expect(rendered).not_to match('New image')
    end
  end
end