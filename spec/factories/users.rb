# == Schema Information
#
# Table name: users
#
#  id                    :bigint           not null, primary key
#  current_login_ip      :string
#  current_login_time    :datetime
#  email                 :text
#  last_login_ip         :string
#  last_login_time       :datetime
#  otp_consumed_timestep :integer
#  otp_secret            :text
#  password_digest       :text
#  password_reset_expiry :datetime
#  password_reset_token  :string
#  username              :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#
FactoryBot.define do
  factory :user, class: 'User' do
    email { 'test@example.com' }
    username { 'test' }
    password { 'Securepass1' }

    trait :with_totp do
      otp_secret { ROTP::Base32.random }
    end
  end

  factory :user2, class: 'User' do
    email { 'test2@example.com' }
    username { 'test2' }
    password { 'Securepass2' }
  end
end
