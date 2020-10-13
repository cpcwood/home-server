FactoryBot.define do
  factory :user, class: 'User' do
    email { 'test@example.com' }
    username { 'test' }
    password { 'Securepass1' }
    mobile_number { '+447123456789' }
  end

  factory :user2, class: 'User' do
    email { 'test2@example.com' }
    username { 'test2' }
    password { 'Securepass2' }
    mobile_number { '+447234567891' }
  end
end