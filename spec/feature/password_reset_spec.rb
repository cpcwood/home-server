feature 'Password Reset' do
  scenario 'Filling in password reset form' do
    stub_request(:post, 'https://www.google.com/recaptcha/api/siteverify?response&secret=test')
      .to_return(status: 200, body: '{"success": true}', headers: {})
    visit('/login')
    click_on('Forgotten Password')
    fill_in('email', with: 'admin@example.com')
    click_button('Request Password Reset')
    expect(page).to have_content('If the submitted email is associated with an account, a password reset link will be sent')
    expect(current_path).to eq('/login')
    expect(PasswordResetJob).to have_been_enqueued.exactly(:once)
    p @test_user.password_reset_token
  end
end