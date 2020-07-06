require 'rails_helper'
require 'helpers/session_helper'

RSpec.describe 'Users', type: :request do
  describe 'PUT /user.id #update' do
    it 'Redirects to homepage if user not logged in' do
      put "/users.#{@test_user.id}"
      expect(response.status).to eq(401)
    end

    it 'Original password must be present to update section' do
      login
      put "/users.#{@test_user.id}", params: { username: { username: 'new_username', username_confirmation: 'new_username' }, current_password: { password: '' }}
      follow_redirect!
      expect(response.body).to include('Enter current password to update details')
    end

    it 'Username can be updated' do
      login
      put "/users.#{@test_user.id}", params: { username: { username: 'new_username', username_confirmation: 'new_username' }, current_password: { password: @test_user_password }}
      follow_redirect!
      expect(response.body).to include('User updated!')
      @test_user.reload
      expect(@test_user.username).to eq('new_username')
    end

    it 'Username not updated if fields are left empty' do
      original_username = @test_user.username
      login
      put "/users.#{@test_user.id}", params: { username: { username: '', username_confirmation: '' }, current_password: { password: @test_user_password }}
      expect(response).to redirect_to(admin_user_settings_path)
      @test_user.reload
      expect(@test_user.username).to eq(original_username)
    end

    it 'Username update validation errors get displayed' do
      login
      put "/users.#{@test_user.id}", params: { username: { username: 'new_username', username_confirmation: '' }, current_password: { password: @test_user_password }}
      follow_redirect!
      expect(response.body).to include('Usernames do not match')
    end
  end
end