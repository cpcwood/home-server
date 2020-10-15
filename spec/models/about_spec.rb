# == Schema Information
#
# Table name: abouts
#
#  id            :bigint           not null, primary key
#  about_me      :text
#  github_link   :string
#  linkedin_link :string
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

RSpec.describe About, type: :model do
  let(:image_file_upload) { fixture_file_upload(Rails.root.join('spec/files/sample_image.jpg'), 'image/jpg') }
  let(:about) { create(:about) }

  context 'validations' do
    describe 'linkedin_link' do
      it 'is link' do
        about.linkedin_link = 'not a link'
        expect(about).to_not be_valid
        expect(about.errors.messages[:linkedin_link]).to eq ['Linkedin link is not valid']
        about.linkedin_link = 'http://example.com'
        expect(about).to be_valid
      end
    end
  end

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
