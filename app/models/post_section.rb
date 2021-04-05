# == Schema Information
#
# Table name: post_sections
#
#  id         :bigint           not null, primary key
#  order      :integer          default(0), not null
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#
# Indexes
#
#  index_post_sections_on_post_id  (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#
class PostSection < ApplicationRecord
  belongs_to :post

  has_one :post_section_image, dependent: :destroy, inverse_of: :post_section
  accepts_nested_attributes_for :post_section_image, allow_destroy: true
  validates_associated :post_section_image

  validates :order,
            presence: { message: 'Post Section order cannot be nil' }
end
