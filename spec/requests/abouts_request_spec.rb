RSpec.describe 'Request Abouts', type: :request do
  before(:each) do
    seed_test_user
    seed_about
  end

  it 'Renders about page' do
    get '/about'
    expect(response).to render_template(:index)
  end
end
