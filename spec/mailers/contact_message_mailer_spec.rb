RSpec.describe ContactMessageMailer, type: :mailer do
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

    it 'Renders the receivers email' do
      expect(mail.to).to eql([about.contact_email])
    end

    it 'Renders the sender email correctly' do
      expect(mail.from).to eql([Rails.application.credentials.email[:no_reply_email]])
    end

    it 'Renders the reply to email' do
      expect(mail.reply_to).to eql([contact_message.email])
    end

    it 'Renders the subject' do
      expect(mail.subject).to eql("New contact message: #{contact_message.subject}")
    end

    it 'Assigns greeting in email' do
      expect(mail.body.encoded).to match(/Hi[\w\W]+#{about.name}/)
    end

    it 'Assigns intro message' do
      expect(mail.body.encoded).to match(/You have received a new contact message from:[\w ]+#{contact_message.from}/)
    end
  end


  describe '#confirmation' do
    let(:mail) { ContactMessageMailer.with(contact_message: contact_message).confirmation }

    it 'Renders the receivers email' do
      expect(mail.to).to eql([contact_message.email])
    end

    it 'Renders the sender email correctly' do
      expect(mail.from).to eql([Rails.application.credentials.email[:no_reply_email]])
    end

    it 'Renders the subject' do
      expect(mail.subject).to eql("Contact message sent: #{contact_message.subject}")
    end
  end
end