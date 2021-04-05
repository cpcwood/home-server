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
FactoryBot.define do
  factory :post_section_image do
    
  end
end
