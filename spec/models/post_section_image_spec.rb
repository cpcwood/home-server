# == Schema Information
#
# Table name: post_section_images
#
#  id              :bigint           not null, primary key
#  description     :string           default("post-image"), not null
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  post_section_id :bigint           not null
#
# Indexes
#
#  index_post_section_images_on_post_section_id  (post_section_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_section_id => post_sections.id)
#
require 'rails_helper'

RSpec.describe PostSectionImage, type: :model do
  subject { create(:post_section_image) }

  describe '#variant_sizes' do
    it 'default_value' do
      expect(subject.variant_sizes).to eq(PostSectionImage::VARIANT_SIZES)
    end
  end

  describe '#description' do
    it 'if title present' do
      subject.title = 'test title'
      subject.description = 'test description'
      subject.save
      expect(subject.description).to eq(subject.title)
    end

    it 'if title nil' do
      subject.title = nil
      expect {subject.save}.not_to change { subject.description }
    end
  end
end
