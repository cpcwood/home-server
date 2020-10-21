describe 'Views' do
  let(:user) { build_stubbed(:user) }
  let(:gallery_image1) { build_stubbed(:gallery_image, user: user) }
  let(:gallery_image2) { build_stubbed(:gallery_image, user: user) }
  let(:gallery_images) { [gallery_image1, gallery_image2] }

  describe '/admin/gallery rendering' do
    before(:each) do
      allow_any_instance_of(AdminLinkHelper).to receive(:in_admin_scope?).and_return(true)
    end

    context 'index view' do
      before(:each) do
        assign(:gallery_images, gallery_images)
        assign(:user, user)
        render template: '/admin/gallery_images/index.html.erb'
      end

      it 'it renders gallery_images' do
        expect(rendered).to match(gallery_image1.description)
        expect(rendered).to match(gallery_image2.description)
        expect(rendered).to match('toolbar-container')
      end

      it 'no gallery_images' do
        assign(:gallery_images, [])
        assign(:user, user)
        render template: 'gallery_images/index.html.erb'
        expect(rendered).to match('There are no images here...')
      end
    end
  end
end