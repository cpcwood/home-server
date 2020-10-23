describe 'Views' do
  let(:gallery_image) { create(:gallery_image) }

  describe '/admin/gallery-images/:id/edit rendering' do
    context 'edit view' do
      before(:each) do
        gallery_image
        assign(:gallery_image, gallery_image)
        render template: 'admin/gallery_images/edit.html.erb'
      end

      it 'it renders posts' do
        expect(rendered).to match(Regexp.escape(gallery_image.description))
        expect(rendered).to match(Regexp.escape(gallery_image.latitude.to_s))
        expect(rendered).to match(Regexp.escape(gallery_image.longitude.to_s))
        expect(rendered).to match(admin_gallery_image_path(gallery_image))
      end
    end
  end
end