Spec.describe 'Posts', type: :request do
  it 'Renders posts index page' do
    get '/posts'
    expect(response).to render_template(:index)
  end
end
