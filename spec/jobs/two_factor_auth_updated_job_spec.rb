RSpec.describe TwoFactorAuthUpdatedJob, type: :job do
  let(:user) { build_stubbed(:user) }

  it 'Two factor auth updated email sent' do
    expect(user).to receive(:send_two_factor_auth_updated_email!)
    TwoFactorAuthUpdatedJob.perform_now(user: user)
  end
end
