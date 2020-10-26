RSpec.describe ContactMessageMailer, type: :mailer do
  include DateHelper

  let(:about) { create(:about) }
  let(:user) { build_stubbed(:user) }
  let(:contact_message) { build_stubbed(:contact_message, user: user) }
  let(:header_image) { create(:header_image, site_setting: create(:site_setting)) }
  let(:image_name) { 'image_mock.jpg' }
  let(:image_attachment) { fixture_file_upload(Rails.root.join("spec/files/#{image_name}"), 'image/png') }

  before(:each) do
    about
    user
    header_image
  end

  describe '#contact_message' do
    let(:mail) { ContactMessageMailer.with(contact_message: contact_message).contact_message }

    it 'renders the receivers email' do
      expect(mail.to).to eql([about.contact_email])
    end

    it 'renders the sender email correctly' do
      expect(mail.from).to eql([Rails.application.credentials.email[:no_reply_email]])
    end

    it 'renders the reply to email' do
      expect(mail.reply_to).to eql([contact_message.email])
    end

    it 'renders the subject' do
      expect(mail.subject).to eql("New contact message: #{contact_message.subject}")
    end

    it 'renders greeting in email' do
      expect(mail.body.encoded).to match(/Hi[\w\W]+#{about.name}/)
    end

    it 'renders intro message' do
      expect(mail.body.encoded).to match(/You have received a new contact message from:[\w ]+#{contact_message.from}/)
    end

    it 'renders message timestamp' do
      expect(mail.body.encoded).to match(full_date_and_time(contact_message.created_at))
    end

    it 'renders message content' do
      expect(mail.body.encoded).to match(contact_message.content)
    end

    it 'Renders attached header image path' do
      header_image.image_file.attach(image_attachment)
      expect(mail.body.encoded).to match(image_name)
    end
  end

  describe '#confirmation' do
    let(:mail) { ContactMessageMailer.with(contact_message: contact_message).confirmation }

    it 'renders the receivers email' do
      expect(mail.to).to eql([contact_message.email])
    end

    it 'renders the sender email correctly' do
      expect(mail.from).to eql([Rails.application.credentials.email[:no_reply_email]])
    end

    it 'renders the subject' do
      expect(mail.subject).to eql("Contact message sent: #{contact_message.subject}")
    end

    it 'renders greeting in email' do
      expect(mail.body.encoded).to match(/Hi[\w\W]+#{contact_message.from}/)
    end

    it 'renders intro message' do
      expect(mail.body.encoded).to match(/You sent a new contact message to:[\w ]+#{about.name}/)
    end

    it 'renders message timestamp' do
      expect(mail.body.encoded).to match(full_date_and_time(contact_message.created_at))
    end

    it 'renders message content' do
      expect(mail.body.encoded).to match(contact_message.content)
    end

    it 'Renders attached header image path' do
      header_image.image_file.attach(image_attachment)
      expect(mail.body.encoded).to match(image_name)
    end
  end
end