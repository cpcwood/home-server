require 'rails_helper'

RSpec.describe PasswordMailer, type: :mailer do
  describe '#password_reset_email' do
    let(:mail) { PasswordMailer.with(user: @test_user).password_reset_email }

    it 'renders the receiver email' do
      expect(mail.to).to eql([@test_user.email])
    end

    it 'renders the subject' do
      expect(mail.subject).to eql("Password Reset: #{@test_user.email}")
    end
  end
end