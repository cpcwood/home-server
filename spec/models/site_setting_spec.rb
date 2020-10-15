# == Schema Information
#
# Table name: site_settings
#
#  id                   :bigint           not null, primary key
#  name                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  typed_header_enabled :boolean
#  header_text          :string
#  subtitle_text        :string
#

RSpec.describe SiteSetting, type: :model do
  subject { create(:site_setting) }

  describe 'name validations' do
    it 'rejects too short' do
      subject.name = ''
      expect(subject).to_not be_valid
      expect(subject.errors.messages[:name]).to eq(['Site name cannot be blank'])
    end

    it 'rejects too long' do
      subject.name = '0' * 256
      expect(subject).to_not be_valid
      expect(subject.errors.messages[:name]).to eq(['Site name cannot be longer than 255 charaters'])
    end

    it 'accepts correct length' do
      subject.name = '0'
      expect(subject).to be_valid
      subject.name = '0' * 255
      expect(subject).to be_valid
    end
  end

  describe 'typed_header_enabled validations' do
    it 'data type' do
      subject.typed_header_enabled = nil
      expect(subject).to_not be_valid
      subject.typed_header_enabled = true
      expect(subject).to be_valid
    end
  end

  describe 'header_text validations' do
    it 'max length' do
      subject.header_text = '0' * 256
      expect(subject).to_not be_valid
      expect(subject.errors.messages[:header_text]).to eq(['Header text cannot be longer than 255 charaters'])
      subject.header_text = '0' * 255
      expect(subject).to be_valid
    end
  end

  describe 'subtitle_text validations' do
    it 'max length' do
      subject.subtitle_text = '0' * 256
      expect(subject).to_not be_valid
      expect(subject.errors.messages[:subtitle_text]).to eq(['Subtitle text cannot be longer than 255 charaters'])
      subject.subtitle_text = '0' * 255
      expect(subject).to be_valid
    end
  end

  describe '#change_messages' do
    it 'no change' do
      expect(subject.reload.change_messages).to eq([])
    end

    it 'attribute changes' do
      subject.reload
      subject.update(name: 'new name', header_text: 'new header')
      expect(subject.change_messages).to eq(['Name updated!', 'Header text updated!'])
    end
  end
end
