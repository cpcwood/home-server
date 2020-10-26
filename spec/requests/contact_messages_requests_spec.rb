RSpec.describe 'ContactMessages', type: :request do
  before(:each) do
    seed_user_and_settings
  end

  let(:valid_params) {
    { contact_message: {
        from: 'test user',
        email: 'test@example.com',
        subject: 'new message subject',
        content: 'new message text content'
      }
    }
  }

  describe 'GET /contact' do
    it 'sucessful request' do
      get('/contact')
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /contact-messages' do
    it 'sucessful request' do
      expect{ post('/contact-messages', params: valid_params) }.to change{ ContactMessage.all.length }.from(0).to(1)
      expect(response).to redirect_to(contact_path)
      expect(flash[:notice]).to include('Message sent! You should receive a confirmation email shortly.')
      # expect mailerjobs to be made
    end
  end
end
