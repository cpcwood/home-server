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
FactoryBot.define do
  factory :code_snippet do
    title { 'a code snippet' }
    overview { 'snippet overview' }
    snippet { "const codeSnippet = () => console.log('code snippet');" }
    text { 'some explaination for the snippet' }
    extension { 'js' }
    user
  end
end
