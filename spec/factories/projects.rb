# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  date        :datetime         not null
#  extension   :string
#  github_link :string
#  overview    :text
#  site_link   :string
#  snippet     :text
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :project do
    title { 'MyString' }
    overview { 'MyText' }
    date { '2020-10-29 11:59:27' }
    github_link { 'MyString' }
    site_link { 'MyString' }
    snippet { 'MyText' }
    extension { 'rb' }
  end
end
