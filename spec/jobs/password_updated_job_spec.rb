RSpec.describe PasswordUpdatedJob, type: :job do
  let(:user) { build_stubbed(:user) }

  it 'Password reset email sent' do
    expect(user).to receive(:send_password_updated_email!)
    PasswordUpdatedJob.perform_now(user: user)
  end
end
