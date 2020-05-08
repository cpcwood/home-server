require 'rails_helper'
require 'bcrypt'

RSpec.describe User, type: :model do
  describe '#generate_password_reset_token!' do
    it 'adds a password reset token to user' do
      allow(SecureRandom).to receive(:urlsafe_base64).and_return('testtoken')
      @test_user.generate_password_reset_token!
      expect(BCrypt::Password.new(@test_user.password_reset_token) == 'testtoken').to eq(true)
    end
  end
end
