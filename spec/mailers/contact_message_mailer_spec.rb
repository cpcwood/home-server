RSpec.describe ContactMessageMailer, type: :mailer do
  let(:about) {build_stubbed(:about)}
  let(:user) { build_stubbed(:user) }
  let(:contact_message) { build_stubbed(:contact_message, user: user) }
  let(:header_image) { create(:header_image, site_setting: create(:site_setting)) }
  let(:image_name) { 'image_mock.jpg' }
  let(:image_attachment) { fixture_file_upload(Rails.root.join("spec/files/#{image_name}"), 'image/png') }

  before(:each) do
    header_image
  end

  describe '#contact_message' do
    let(:mail) { ContactMessageMailer.with(contact_message: contact_message, deliver_to: about.contact_email).contact_message }

    it 'Renders the receivers email' do
      expect(mail.to).to eql([about.contact_email])
    end

    it 'Renders the sender email correctly' do
      expect(mail.from).to eql([Rails.application.credentials.email[:no_reply_email]])
    end
  end
end