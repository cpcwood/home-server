RSpec.describe 'Request Admin:Base', type: :request do
  before(:each) do
    seed_db
  end

  describe 'before_action:' do
    describe 'check_admin_logged_in' do
      it 'admin not logged in' do
        get '/admin/images'
        expect(response).to redirect_to('/')
      end

      it 'admin logged in' do
        login
        get '/admin/images'
        expect(response.status).to eq(200)
      end
    end
  end
end