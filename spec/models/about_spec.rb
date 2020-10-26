# == Schema Information
#
# Table name: abouts
#
#  id            :bigint           not null, primary key
#  about_me      :text
#  contact_email :string           not null
#  github_link   :string
#  linkedin_link :string
#  location      :string           not null
#  name          :string           not null
#  section_title :string
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
        about.linkedin_link = ''
        expect(about).to be_valid
      end
    end

    describe 'github_link' do
      it 'is link' do
        about.github_link = 'not a link'
        expect(about).to_not be_valid
        expect(about.errors.messages[:github_link]).to eq ['Github link is not valid']
        about.github_link = ''
        expect(about).to be_valid
      end
    end

    describe 'name' do
      it 'format' do
        about.name = nil
        expect(about).to_not be_valid
        about.name = ''
        expect(about).to_not be_valid
        expect(about.errors.messages[:name]).to eq ['Name cannot be blank']
        about.name = 'a'
        expect(about).to be_valid
      end
    end

    describe 'location' do
      it 'format' do
        about.location = nil
        expect(about).to_not be_valid
        about.location = ''
        expect(about).to_not be_valid
        expect(about.errors.messages[:location]).to eq ['Location cannot be blank']
        about.location = 'a'
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
      expect(about.change_messages).to include('Name updated!')
      expect(about.change_messages).to include('About me updated!')
    end

    it 'attachment changes' do
      about.update(profile_image_attributes: {
                     image_file: image_file_upload
                   })
      expect(about.change_messages).to eq(['Profile image updated!'])
    end
  end
end
