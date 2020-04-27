require 'rails_helper'

RSpec.describe "Abouts", type: :request do
  it 'Renders About page' do 
    get '/about'
    expect(response).to render_template(:index)
  end
end
