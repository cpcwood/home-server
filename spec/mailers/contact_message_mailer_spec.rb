RSpec.describe ContactMessageMailer, type: :mailer do
  let(:user) { build_stubbed(:user) }
  let(:contact_message) { build_stubbed(:contact_message, user: user) }
  let(:header_image) { create(:header_image, site_setting: create(:site_setting)) }
  let(:image_name) { 'image_mock.jpg' }
  let(:image_attachment) { fixture_file_upload(Rails.root.join("spec/files/#{image_name}"), 'image/png') }

  before(:each) do
    header_image
  end

  describe '#send_contact_message' do
    let(:mail) { ContactMessageMailer.with(contact_message: contact_message).send_contact_message }
  end
end