require 'rails_helper'

RSpec.describe 'Admins', type: :request do
  it 'renders admin landing page' do
    get '/admin'
    expect(response).to render_template(:index)
  end
end
