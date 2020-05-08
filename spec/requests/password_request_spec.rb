require 'rails_helper'

RSpec.describe "Passwords", type: :request do
  describe 'GET /forgotten-password #forgotten_password'
  it 'Renders the forgotten password page' do
    get '/forgotten-password'
    expect(response).to render_template(:forgotten_password)
  end
end
