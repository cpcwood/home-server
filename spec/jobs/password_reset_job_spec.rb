require 'rails_helper'

RSpec.describe PasswordResetJob, type: :job do
  let(:user) { User.create(username: 'admin', email: 'admin@example.com', password: 'Securepass1', mobile_number: '+447123456789') }

  it 'If user exists, password reset email sent' do
    user
    expect_any_instance_of(User).to receive(:send_password_reset_email!)
    PasswordResetJob.perform_now(email: user.email)
  end

  it 'If user does not exist, no email sent' do
    user
    expect_any_instance_of(User).not_to receive(:send_password_reset_email!)
    PasswordResetJob.perform_now(email: 'idontexist@example.com')
  end
end
