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

    it 'Renders signoff with company name' do
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

    it 'Renders signoff with company name' do
      expect(mail.body.encoded).to match("Thanks,\r\n                        <br>\r\n                        <br>\r\n                        #{Rails.application.credentials.email[:company_name]}")
    end

    it 'Renders time at which acount was updated' do
      travel_to Time.zone.local(2020, 04, 19, 12, 10, 00)
      @another_user = User.create(username: 'another_user', password: 'password', email: 'another_user@example.com', mobile_number: '+447234567890')
      mail = PasswordMailer.with(user: @another_user).password_updated_email
      expect(mail.body.encoded).to match('Your password was updated on: 12:10 19-04-2020')
    end
  end
end