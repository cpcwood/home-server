RSpec.describe NewContactMessageJob, type: :job do
  let(:about) { create(:about) }
  let(:contact_message) { build_stubbed(:contact_message) }
  let(:mock_contact_message_mailer) { double(:ContactMessageMailer, deliver_now: nil) }

  it 'Contact message sent' do
    about
    expect(ContactMessageMailer).to receive(:with).twice.and_return(mock_contact_message_mailer)
    expect(mock_contact_message_mailer).to receive(:confirmation).and_return(mock_contact_message_mailer)
    expect(mock_contact_message_mailer).to receive(:contact_message).and_return(mock_contact_message_mailer)

    NewContactMessageJob.perform_now(contact_message: contact_message)
  end
end
