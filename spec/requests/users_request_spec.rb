RSpec.describe 'Request Users', type: :request do
  before(:each) do
    seed_test_user
  end

  describe 'PUT /user.id #update' do
    let(:blank_username_params) { { username: '', username_confirmation: '' } }
    let(:blank_email_params) { { email: '', email_confirmation: '' } }
    let(:blank_password_params) { { password: '', password_confirmation: '' } }
    let(:blank_mobile_number_params) { { mobile_number: '', mobile_number_confirmation: '' } }
    let(:default_current_password_params) { { password: @user_password } }

    it 'Redirects to homepage if user not logged in' do
      put "/users.#{@user.id}"
      expect(response.status).to eq(401)
    end

    it 'Original password must be present to update section' do
      login
      put "/users.#{@user.id}", params: {
        username: {
          username: 'new_username',
          username_confirmation: 'new_username'
        },
        email: blank_email_params,
        password: blank_password_params,
        mobile_number: blank_mobile_number_params,
        current_password: {
          password: ''
        }
      }
      expect(flash[:alert]).to eq('Enter current password to update details')
    end

    it 'Username can be updated' do
      login
      put "/users.#{@user.id}", params: {
        username: {
          username: 'new_username',
          username_confirmation: 'new_username'
        },
        email: blank_email_params,
        password: blank_password_params,
        mobile_number: blank_mobile_number_params,
        current_password: default_current_password_params
      }
      expect(flash[:notice]).to include('Username updated!')
      @user.reload
      expect(@user.username).to eq('new_username')
    end

    it 'Username not updated if fields are left empty' do
      original_username = @user.username
      login
      put "/users.#{@user.id}", params: {
        username: {
          username: '',
          username_confirmation: ''
        },
        email: blank_email_params,
        password: blank_password_params,
        mobile_number: blank_mobile_number_params,
        current_password: default_current_password_params
      }
      expect(response).to redirect_to(admin_user_settings_path)
      @user.reload
      expect(@user.username).to eq(original_username)
    end

    it 'Username update validation errors get displayed' do
      login
      put "/users.#{@user.id}", params: {
        username: {
          username: 'new_username',
          username_confirmation: ''
        },
        email: blank_email_params,
        password: blank_password_params,
        mobile_number: blank_mobile_number_params,
        current_password: default_current_password_params
      }
      expect(flash[:alert]).to include('Usernames do not match')
    end

    it 'Email can be updated' do
      login
      put "/users.#{@user.id}", params: {
        email: {
          email: 'new@example.com',
          email_confirmation: 'new@example.com'
        },
        username: blank_username_params,
        password: blank_password_params,
        mobile_number: blank_mobile_number_params,
        current_password: default_current_password_params
      }
      expect(flash[:notice]).to include('Email address updated!')
      @user.reload
      expect(@user.email).to eq('new@example.com')
    end

    it 'Email update validation errors get displayed' do
      login
      put "/users.#{@user.id}", params: {
        email: {
          email: 'example.com',
          email_confirmation: 'example.com'
        },
        username: blank_username_params,
        password: blank_password_params,
        mobile_number: blank_mobile_number_params,
        current_password: default_current_password_params
      }
      expect(flash[:alert]).to include('Email must be valid format')
    end

    it 'Password can be updated' do
      login
      put "/users.#{@user.id}", params: {
        password: {
          password: 'newpassword',
          password_confirmation: 'newpassword'
        },
        email: blank_email_params,
        username: blank_username_params,
        mobile_number: blank_mobile_number_params,
        current_password: default_current_password_params
      }
      expect(flash[:notice]).to include('Password updated!')
      @user.reload
      expect(@user.authenticate('newpassword')).to eq(@user)
    end

    it 'Password update validation errors get displayed' do
      login
      put "/users.#{@user.id}", params: {
        password: {
          password: 'badpassword',
          password_confirmation: 'newpassword'
        },
        email: blank_email_params,
        username: blank_username_params,
        mobile_number: blank_mobile_number_params,
        current_password: default_current_password_params
      }
      expect(flash[:alert]).to include('Passwords do not match')
    end

    it 'Mobile number can be updated' do
      login
      put "/users.#{@user.id}", params: {
        mobile_number: {
          mobile_number: '07123456789',
          mobile_number_confirmation: '07123456789'
        },
        password: blank_password_params,
        email: blank_email_params,
        username: blank_username_params,
        current_password: default_current_password_params
      }
      expect(flash[:notice]).to include('Mobile number updated!')
      @user.reload
      expect(@user.mobile_number).to eq('+447123456789')
    end
  end
end