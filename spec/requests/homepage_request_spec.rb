require 'rails_helper'

RSpec.describe 'Homepages', type: :request do
  it 'Renders the homepage' do
    get '/'
    expect(response).to render_template(:index)
  end
end
