RSpec.describe NewContactMessageJob, type: :job do
  let(:user) { build_stubbed(:user) }
  let(:contact_message) { build_stubbed(:contact_message) }

  it 'Contact message sent' do
    mock_contact_message_mailer = double(:ContactMessageMailer, deliver_now: nil)
    expect(ContactMessageMailer).to receive(:with).with(message: contact_message, to: user).and_return(mock_contact_message_mailer)
    expect(mock_contact_message_mailer).to receive(:send_contact_message).and_return(mock_contact_message_mailer)
    NewContactMessageJob.perform_now(message: contact_message, to: user)
  end
end
