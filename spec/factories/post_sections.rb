# == Schema Information
#
# Table name: post_sections
#
#  id         :bigint           not null, primary key
#  order      :integer          not null
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :post_section do
    text { "MyText" }
    order { 1 }
  end
end
