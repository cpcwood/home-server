RSpec.describe PasswordMailer, type: :mailer do
  let(:user) { User.create(username: 'admin', email: 'admin@example.com', password: 'Securepass1', mobile_number: '+447123456789') }
  let(:site_setting) { SiteSetting.create(name: 'test_name', typed_header_enabled: false, header_text: 'test header_text', subtitle_text: 'test subtitle_text') }
  let(:header_image) { HeaderImage.create(site_setting: site_setting, description: 'header_image') }
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
      header_image = SiteSetting.first.header_image
      header_image.image_file.attach(
        io: File.open(image_mock_path),
        filename: 'image_mock.jpg')
      expect(mail.body.encoded).to match(image_name)
    end

    it 'Renders default header image path' do
      expect(mail.body.encoded).to match('http://localhost:3001/assets/default_images/default_header_image-5d68de84079940fdf808d15d80c7a75b462c5ef464ef25d88f358b65a984f8dc.jpg')
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

    it 'Renders time at which acount was updated' do
      travel_to Time.zone.local(2020, 04, 19, 12, 10, 00)
      @another_user = User.create(username: 'another_user', password: 'password', email: 'another_user@example.com', mobile_number: '+447234567890')
      mail = PasswordMailer.with(user: @another_user).password_updated_email
      expect(mail.body.encoded).to match('Your password was updated on: 12:10 19-04-2020')
    end

    it 'Renders attached header image path' do
      image_name = 'image_mock.jpg'
      header_image = SiteSetting.first.header_image
      header_image.image_file.attach(
        io: File.open(image_mock_path),
        filename: 'image_mock.jpg')
      expect(mail.body.encoded).to match(image_name)
    end

    it 'Renders default header image path' do
      expect(mail.body.encoded).to match('http://localhost:3001/assets/default_images/default_header_image-5d68de84079940fdf808d15d80c7a75b462c5ef464ef25d88f358b65a984f8dc.jpg')
    end
  end
end