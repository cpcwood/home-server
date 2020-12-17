RSpec.describe 'AboutsController', type: :request do
  before(:each) do
    seed_user_and_settings
    seed_about
  end

  it 'Renders about page' do
    get '/about'
    expect(response).to render_template(:show)
  end
end
