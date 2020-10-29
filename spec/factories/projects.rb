# == Schema Information
#
# Table name: projects
#
#  id            :bigint           not null, primary key
#  date          :datetime         not null
#  extension     :string
#  github_link   :string
#  overview      :text
#  site_link     :string
#  snippet       :text
#  title         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  main_image_id :bigint
#
# Indexes
#
#  index_projects_on_main_image_id  (main_image_id)
#
# Foreign Keys
#
#  fk_rails_...  (main_image_id => project_images.id)
#
FactoryBot.define do
  factory :project do
    title { 'MyString' }
    overview { 'MyText' }
    date { '2020-10-29 11:59:27' }
    github_link { 'https://github.com/' }
    site_link { 'https://example.com/' }
    snippet { 'MyText' }
    extension { 'rb' }
    main_image_id { nil }
  end
end
