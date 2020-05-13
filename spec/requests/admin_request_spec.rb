require 'rails_helper'

RSpec.describe 'Admins', type: :request do
  it 'Redirects to homepage if user not logged in' do
    get '/admin'
    expect(response).to redirect_to('/')
  end
end
