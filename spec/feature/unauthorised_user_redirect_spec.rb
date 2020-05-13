feature 'Unauthorised user redirect' do
  scenario 'Only logged in user can access admin page' do
    visit('/admin')
    expect(page).to have_current_path('/')
  end
end