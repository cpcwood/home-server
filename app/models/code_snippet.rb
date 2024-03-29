# == Schema Information
#
# Table name: code_snippets
#
#  id         :bigint           not null, primary key
#  extension  :string           not null
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

  has_one :code_snippet_image, dependent: :destroy

  validates :title,
            length: { minimum: 1, maximum: 60, message: 'Title length must be between 1 and 60 charaters' }

  validates :overview,
            length: { minimum: 1, maximum: 160, message: 'Overview length must be between 1 and 160 charaters' }

  validates :snippet,
            length: { minimum: 1, message: 'Code snippet cannot be blank' }

  validates :extension,
            format: { with: /\A[a-zA-Z0-9]+\z/, message: 'Code must be valid file extension' }

  after_commit :render_code_snippet

  def render_code_snippet
    RenderCodeSnippetJob.set(wait: 5.seconds).perform_later(model: create_code_snippet_image, snippet: snippet, extension: extension) if snippet_previously_changed?
  end

  def to_param
    parameterized_title = "-#{title.parameterize}" if title.present?
    "#{id}#{parameterized_title}"
  end
end
