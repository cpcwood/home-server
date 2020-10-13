FactoryBot.define do
  factory :user, class: 'User' do
    email { 'test@example.com' }
    username { 'test' }
    password { 'Securepass1' }
    mobile_number { '+447123456789' }
  end
end