RSpec.describe 'Posts', type: :request do
  before(:each) do
    seed_db
  end

  it 'Renders posts index page' do
    get '/blog'
    expect(response).to render_template(:index)
  end
end
