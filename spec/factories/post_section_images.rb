# == Schema Information
#
# Table name: post_section_images
#
#  id          :bigint           not null, primary key
#  description :string           default("post-image"), not null
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :post_section_image do
    
  end
end
