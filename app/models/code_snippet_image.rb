# == Schema Information
#
# Table name: code_snippet_images
#
#  id              :bigint           not null, primary key
#  description     :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  code_snippet_id :bigint           not null
#
# Indexes
#
#  index_code_snippet_images_on_code_snippet_id  (code_snippet_id)
#
# Foreign Keys
#
#  fk_rails_...  (code_snippet_id => code_snippets.id)
#
class CodeSnippetImage < Image
  belongs_to :code_snippet

  X_DIM = 1000
  Y_DIM = 750

  before_validation :set_defaults

  def set_defaults
    self.description ||= 'code-snippet-image'
  end

  def x_dim
    X_DIM
  end

  def y_dim
    Y_DIM
  end
end
