describe 'Views' do
  let(:profile_image) { build_stubbed(:profile_image) }
  let(:about) { build_stubbed(:about) }
  let(:about_attached_image) { build_stubbed(:about, profile_image: profile_image) }

  describe 'admin/about rendering' do
    it 'default view' do
      assign(:about, about)

      render template: 'admin/abouts/edit.html.erb'

      expect(rendered).to match(about.name)
      expect(rendered).to match(about.about_me)
      expect(rendered).to match("Images will be resized to #{profile_image.x_dim}")
      expect(rendered).to match(profile_image.y_dim.to_s)
    end

    it 'No image attached' do
      about.profile_image = nil
      assign(:about, about)

      render template: 'admin/abouts/edit.html.erb'

      expect(rendered).to match('New image')
      expect(rendered).not_to match('Update image')
      expect(rendered).not_to match('Remove image')
    end

    it 'image attached' do
      assign(:about, about_attached_image)

      render template: 'admin/abouts/edit.html.erb'

      expect(rendered).to match('Update image')
      expect(rendered).to match('Remove image')
      expect(rendered).not_to match('New image')
    end
  end
end