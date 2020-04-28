require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  it 'renders login page' do
    get '/login'
    expect(response).to render_template(:login)
  end
end
