require 'rails_helper'

RSpec.describe 'Abouts', type: :request do
  it 'Renders about page' do
    get '/about'
    expect(response).to render_template(:index)
  end
end
