feature 'Unauthorised user redirect', feature: true do
  before(:each) do
    seed_db
  end

  scenario 'Only logged in user can access admin page' do
    visit('/admin')
    expect(page).to have_current_path('/')
  end
end