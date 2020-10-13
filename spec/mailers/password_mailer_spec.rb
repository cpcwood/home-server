RSpec.describe PasswordMailer, type: :mailer do
  let(:user) { build_stubbed(:user) }
  let(:header_image) { create(:header_image, site_setting: create(:site_setting)) }
  let(:image_mock_path) { Rails.root.join('spec/files/image_mock.jpg') }

  before(:each) do
    header_image
  end

  describe '#password_reset_email' do
    let(:mail) { PasswordMailer.with(user: user).password_reset_email }

    it 'Renders the receivers email' do
      expect(mail.to).to eql([user.email])
    end

    it 'Renders the sender email correctly' do
      expect(mail.from).to eql([Rails.application.credentials.email[:no_reply_email]])
    end

    it 'Renders the subject' do
      expect(mail.subject).to eql("Password Reset: #{user.email}")
    end

    it 'Assigns greeting in email' do
      expect(mail.body.encoded).to match("Hi #{user.username},")
    end

    it 'Assigns adds password reset url' do
      user.password_reset_token = 'hashed-token'
      expect(mail.body.encoded).to include(reset_password_url(reset_token: 'hashed-token'))
    end

    it 'Provides contact email' do
      expect(mail.body.encoded).to match("please contact #{Rails.application.credentials.email[:default_email]}")
    end

    it 'Renders signoff with company name' do
      expect(mail.body.encoded).to match("Thanks,\r\n                        <br>\r\n                        <br>\r\n                        #{Rails.application.credentials.email[:company_name]}")
    end

    it 'Renders attached header image path' do
      image_name = 'image_mock.jpg'
      header_image.image_file.attach(
        io: File.open(image_mock_path),
        filename: 'image_mock.jpg')
      expect(mail.body.encoded).to match(image_name)
    end

    it 'Renders default header image path' do
      expect(mail.body.encoded).to match(/default_header_image-\w+.jpg/)
    end
  end

  describe '#password_updated_email' do
    let(:mail) { PasswordMailer.with(user: user).password_updated_email }

    it 'Renders the receivers email' do
      expect(mail.to).to eql([user.email])
    end

    it 'Renders the sender email correctly' do
      expect(mail.from).to eql([Rails.application.credentials.email[:no_reply_email]])
    end

    it 'Renders the subject' do
      expect(mail.subject).to eql("Your Password Has Been Updated: #{user.email}")
    end

    it 'Assigns greeting in email' do
      expect(mail.body.encoded).to match("Hi #{user.username},")
    end

    it 'Provides contact email' do
      expect(mail.body.encoded).to match("please contact #{Rails.application.credentials.email[:default_email]}")
    end

    it 'Renders signoff with company name' do
      expect(mail.body.encoded).to match("Thanks,\r\n                        <br>\r\n                        <br>\r\n                        #{Rails.application.credentials.email[:company_name]}")
    end

    it 'Renders time at which account was updated' do
      travel_to Time.zone.local(2020, 04, 19, 12, 10, 00)
      another_user = build_stubbed(:user)
      mail = PasswordMailer.with(user: another_user).password_updated_email
      expect(mail.body.encoded).to match('Your password was updated on: 12:10 19-04-2020')
    end

    it 'Renders attached header image path' do
      image_name = 'image_mock.jpg'
      header_image.image_file.attach(
        io: File.open(image_mock_path),
        filename: 'image_mock.jpg')
      expect(mail.body.encoded).to match(image_name)
    end

    it 'Renders default header image path' do
      expect(mail.body.encoded).to match(/default_header_image-\w+.jpg/)
    end
  end
end