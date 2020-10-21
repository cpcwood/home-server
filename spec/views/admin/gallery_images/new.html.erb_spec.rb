describe 'Views' do
  let(:gallery_image) { build(:gallery_image) }

  describe '/admin/gallery_images/new rendering' do
    context 'new view' do
      before(:each) do
        assign(:gallery_image, gallery_image)
        render template: '/admin/gallery_images/new.html.erb'
      end

      it 'gallery image form' do
        expect(rendered).to match('gallery_image_image_file')
        expect(rendered).to match('gallery_image_description')
        expect(rendered).to match('gallery_image_date_taken')
        expect(rendered).to match('gallery_image_latitude')
        expect(rendered).to match('gallery_image_longitude')
        expect(rendered).to match(admin_gallery_images_path(GalleryImage.new))
      end
    end
  end
end