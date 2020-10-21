RSpec.describe 'Request Homepages', type: :request do
  before(:each) do
    seed_user_and_settings
  end

  it 'Renders the homepage' do
    get '/'
    expect(response).to render_template(:index)
  end
end
