RSpec.describe NewContactMessageJob, type: :job do
  let(:contact_message) { build_stubbed(:contact_message) }

  it 'Contact message sent' do
    mock_contact_message_mailer = double(:ContactMessageMailer, deliver_now: nil)
    expect(ContactMessageMailer).to receive(:with).with(message: contact_message).and_return(mock_contact_message_mailer)
    expect(mock_contact_message_mailer).to receive(:send_contact_message).and_return(mock_contact_message_mailer)
    NewContactMessageJob.perform_now(contact_message: contact_message)
  end
end
