# == Schema Information
#
# Table name: post_sections
#
#  id         :bigint           not null, primary key
#  order      :integer          default(0), not null
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PostSection < ApplicationRecord

  validates :order,
    presence: { message: 'Post Section order cannot be nil' }
end
