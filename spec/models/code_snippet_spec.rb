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
require 'rails_helper'

RSpec.describe CodeSnippet, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
