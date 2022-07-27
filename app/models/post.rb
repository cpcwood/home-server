# == Schema Information
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  date_published :datetime         not null
#  overview       :string           not null
#  title          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user

  has_many :post_sections, -> { order(order: :asc) }, dependent: :destroy, inverse_of: :post
  accepts_nested_attributes_for :post_sections, allow_destroy: true
  validates_associated :post_sections

  validates :date_published,
            date: { message: 'Date published must be date' }

  validates :overview,
            length: { minimum: 1, message: 'Blog post overview cannot be empty' }

  validates :title,
            length: { minimum: 1, message: 'Blog post title cannot be empty' }

  def to_param
    parameterized_title = "-#{title.parameterize}" if title&.present?
    "#{id}#{parameterized_title}"
  end
end
