RSpec.describe 'Request Homepages', type: :request do
  before(:each) do
    seed_db
  end

  it 'Renders the homepage' do
    get '/'
    expect(response).to render_template(:index)
  end
end
