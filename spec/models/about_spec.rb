# == Schema Information
#
# Table name: abouts
#
#  id         :bigint           not null, primary key
#  name       :string
#  about_me   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

RSpec.describe About, type: :model do
  let(:image_file_upload) { fixture_file_upload(Rails.root.join('spec/files/sample_image.jpg'), 'image/jpg') }
  let(:about) { create(:about) }

  describe '#change_messages' do
    it 'no changes' do
      about.reload
      expect(about.change_messages).to eq([])
    end

    it 'attribute changes' do
      about.update(name: 'new name', about_me: 'new description')
      expect(about.change_messages).to eq(['Name updated!', 'About me updated!'])
    end

    it 'attachment changes' do
      about.update(profile_image_attributes: {
                     image_file: image_file_upload
                   })
      expect(about.change_messages).to eq(['Profile image updated!'])
    end
  end
end
