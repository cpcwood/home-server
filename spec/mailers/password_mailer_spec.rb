require 'rails_helper'

RSpec.describe PasswordMailer, type: :mailer do
  describe '#password_reset_email' do
    let(:mail) { PasswordMailer.with(user: @test_user).password_reset_email }

    it 'Renders the receivers email' do
      expect(mail.to).to eql([@test_user.email])
    end

    it 'Renders the sender email correctly' do
      expect(mail.from).to eql([Rails.application.credentials.email[:no_reply_email]])
    end

    it 'Renders the subject' do
      expect(mail.subject).to eql("Password Reset: #{@test_user.email}")
    end

    it 'Assigns greeting in email' do
      expect(mail.body.encoded).to match("Hi #{@test_user.username},")
    end

    it 'Assigns adds password reset url' do
      @test_user.password_reset_token = 'hashed-token'
      expect(mail.body.encoded).to include(reset_password_url(reset_token: 'hashed-token'))
    end

    it 'Provides contact email' do
      expect(mail.body.encoded).to match("please contact #{Rails.application.credentials.email[:default_email]}")
    end

    it 'Redners signoff with company name' do
      expect(mail.body.encoded).to match("Thanks,\r\n                        <br>\r\n                        <br>\r\n                        #{Rails.application.credentials.email[:company_name]}")
    end
  end

  describe '#password_updated_email' do
    let(:mail) { PasswordMailer.with(user: @test_user).password_updated_email }

    it 'Renders the receivers email' do
      expect(mail.to).to eql([@test_user.email])
    end

    it 'Renders the sender email correctly' do
      expect(mail.from).to eql([Rails.application.credentials.email[:no_reply_email]])
    end

    it 'Renders the subject' do
      expect(mail.subject).to eql("Your Password Has Been Updated: #{@test_user.email}")
    end

    it 'Assigns greeting in email' do
      expect(mail.body.encoded).to match("Hi #{@test_user.username},")
    end

    it 'Provides contact email' do
      expect(mail.body.encoded).to match("please contact #{Rails.application.credentials.email[:default_email]}")
    end

    it 'Redners signoff with company name' do
      expect(mail.body.encoded).to match("Thanks,\r\n\r\n#{Rails.application.credentials.email[:company_name]}")
    end
  end
end