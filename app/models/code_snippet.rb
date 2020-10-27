# == Schema Information
#
# Table name: code_snippets
#
#  id         :bigint           not null, primary key
#  overview   :string           not null
#  snippet    :text             not null
#  text       :text
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_code_snippets_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class CodeSnippet < ApplicationRecord
  belongs_to :user

  validates :title,
            length: { minimum: 1, maximum: 50, message: 'Title length must be between 1 and 50 charaters' }

  validates :overview,
            length: { minimum: 1, maximum: 160, message: 'Overview length must be between 1 and 160 charaters' }
end
