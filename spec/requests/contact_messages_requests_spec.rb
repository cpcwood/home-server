RSpec.describe 'ContactMessages', type: :request do
  before(:each) do
    seed_user_and_settings
  end

  let(:valid_params) do
    { 
      contact_message: {
        from: 'test user',
        email: 'test@example.com',
        subject: 'new message subject',
        content: 'new message text content',
      },
      'g-recaptcha-response' => 'test'
    }
  end

  let(:invalid_params) do
    { 
      contact_message: {
        from: '',
        email: 'test@example.com',
        subject: 'new message subject',
        content: 'new message text content',
      },
      'g-recaptcha-response' => 'test'
    }
  end

  describe 'GET /contact' do
    it 'sucessful request' do
      get('/contact')
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /contact-messages' do
    before(:each) do
      stub_recaptcha_service
      allow(ReCaptchaService).to receive(:recaptcha_valid?).and_return(true)
    end

    it 'sucessful request' do
      expect{ post('/contact-messages', params: valid_params) }.to change{ ContactMessage.all.length }.from(0).to(1)
      expect(response).to redirect_to(contact_path)
      expect(flash[:notice]).to include('Message sent! You should receive a confirmation email shortly.')
      new_message = ContactMessage.first
      expect(NewContactMessageJob).to have_been_enqueued.with(message: new_message)
    end

    it 'save failure' do
      expect{ post('/contact-messages', params: invalid_params) }.not_to(change{ ContactMessage.all.length })
      expect(response).not_to redirect_to(admin_posts_path)
      expect(response.body).to include('From field cannot be blank')
    end

    it 'general error' do
      allow_any_instance_of(ContactMessage).to receive(:save).and_raise('general error')
      expect{ post('/contact-messages', params: valid_params) }.not_to(change{ ContactMessage.all.length })
      expect(response).not_to redirect_to(admin_posts_path)
      expect(response.body).to include('Sorry, something went wrong!')
      expect(response.body).not_to include('general error')
    end

    it 'invalid recaptcha' do
      allow(ReCaptchaService).to receive(:recaptcha_valid?).with(valid_params['g-recaptcha-response']).and_return(false)
      post('/contact-messages', params: valid_params)
      expect(response.body).to include('reCaptcha failed, please try again')
    end
  end
end
