describe 'Views' do
  let(:user) { build_stubbed(:user) }
  let(:gallery_image1) { build_stubbed(:gallery_image, user: user) }
  let(:gallery_image2) { build_stubbed(:gallery_image, user: user) }
  let(:gallery_images) { [gallery_image1, gallery_image2] }

  describe '/blog rendering' do
    it 'index view' do
      assign(:gallery_images, gallery_images)

      render template: 'gallery_images/index.html.erb'

      expect(rendered).to match(gallery_image1.description)
      expect(rendered).to match(gallery_image2.description)
      expect(rendered).not_to match('toolbar-container')
    end

    it 'user signed in' do
      assign(:gallery_images, gallery_images)
      assign(:user, user)

      render template: 'gallery_images/index.html.erb'
      expect(rendered).to match('toolbar-container')
    end

    it 'no gallery_images' do
      assign(:gallery_images, [])
      render template: 'gallery_images/index.html.erb'
      expect(rendered).to match('There are no images here...')
    end
  end
end