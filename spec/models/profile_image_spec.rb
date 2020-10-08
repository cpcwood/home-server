require 'rails_helper'

RSpec.describe ProfileImage, type: :model do
  describe 'before validation' do
    describe '#set_defaults' do
      it 'no description' do
        profile_image = ProfileImage.create
        expect(profile_image.description).to eq('about-me-profile-image')
      end
    end
  end
end