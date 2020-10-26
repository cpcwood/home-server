# == Schema Information
#
# Table name: contact_messages
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  email      :string           not null
#  from       :string           not null
#  subject    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :contact_message do
    
  end
end
