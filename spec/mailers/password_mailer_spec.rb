require 'rails_helper'

RSpec.describe PasswordMailer, type: :mailer do
  describe '#password_reset_email' do
    let(:mail) { PasswordMailer.with(user: @test_user).password_reset_email }

    it 'renders the receiver email' do
      expect(mail.to).to eql([@test_user.email])
    end

    it 'renders the from email correctly' do
      expect(mail.from).to eql([Rails.application.credentials.email[:default_email]])
    end

    it 'renders the subject' do
      expect(mail.subject).to eql("Password Reset: #{@test_user.email}")
    end

    it 'assigns greeting in email' do
      expect(mail.body.encoded).to match("Hi #{@test_user.username},")
    end
  end
end