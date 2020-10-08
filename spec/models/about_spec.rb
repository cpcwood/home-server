require 'rails_helper'

RSpec.describe About, type: :model do
  let(:image_path_valid) { Rails.root.join('spec/files/sample_image.jpg') }
  let(:image_file_upload) { fixture_file_upload(image_path_valid, 'image/jpg') }

  describe '#change_messages' do
    it 'no changes' do
      about = About.create
      about.reload
      expect(about.change_messages).to eq([])
    end

    it 'attribute changes' do
      about = About.create
      about.update(name: 'new name', about_me: 'new description')
      expect(about.change_messages).to eq(['Name updated!', 'About me updated!'])
    end

    it 'attachment changes' do
      about = About.create(profile_image_attributes: {
                             image_file: image_file_upload
                           })
      about.reload
      about.profile_image.reload
      about.update(profile_image_attributes: {
                     image_file: image_file_upload
                   })
      expect(about.change_messages).to eq(['Profile image updated!'])
    end
  end
end
