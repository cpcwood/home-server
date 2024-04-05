feature 'send contact message', feature: true do
  before(:each) do
    seed_user_and_settings
    allow(ReCaptchaService).to receive(:recaptcha_valid?).and_return(true)
  end

  context 'public user' do
    scenario 'send message' do
      visit('/')
      click_on('CONTACT')
      expect(page).to have_current_path('/contact')
      fill_in('contact_message[from]', with: 'new from name')
      fill_in('contact_message[email]', with: 'email@example.com')
      fill_in('contact_message[subject]', with: 'new message')
      fill_in('contact_message[content]', with: 'new contact message')
      expect{ click_on('Send') }.to change{ ContactMessage.all.length }.from(0).to(1)
      new_message = ContactMessage.first
      expect(NewContactMessageJob).to have_been_enqueued.with(contact_message: new_message)
      expect(page).to have_content('Message sent! You should receive a confirmation email shortly.')
    end
  end
end
