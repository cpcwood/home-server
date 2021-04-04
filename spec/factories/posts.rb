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
FactoryBot.define do
  factory :post do
    date_published { DateTime.new(2020, 04, 19, 0, 0, 0) }
    overview { 'test blog post overview' }
    text { 'test blog post content' }
    title { 'test blog post title' }
    user
  end
end
