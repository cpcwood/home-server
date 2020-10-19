# == Schema Information
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  date_published :datetime         not null
#  overview       :string           not null
#  text           :text
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

  validates :date_published,
            timeliness: { message: 'Date published must be date' }

  validates :overview,
            length: { minimum: 1, message: 'Blog post overview cannot be empty' }

  validates :title,
            length: { minimum: 1, message: 'Blog post title cannot be empty' }
end