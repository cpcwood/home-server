require 'rails_helper'
require 'helpers/session_helper'

RSpec.describe 'Users', type: :request do
  describe 'PUT /user.id #update' do
    it 'Username can be update' do
      login
      put "/users.#{@test_user.id}", params: { username: { username: 'new_username', username_confirmation: 'new_username' }}
      follow_redirect!
      expect(response.body).to include('User updated')
      @test_user.reload
      expect(@test_user.username).to eq('new_username')
    end

    it 'Username validation errors displayed' do
      login
    end
  end
end