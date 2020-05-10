require 'rails_helper'

RSpec.describe PasswordResetJob, type: :job do
  it 'If user exists, password reset email sent' do
    expect_any_instance_of(User).to receive(:send_password_reset_email!)
    PasswordResetJob.perform_now(email: 'admin@example.com')
  end

  it 'If user does not exist, no email sent' do
    expect_any_instance_of(User).not_to receive(:send_password_reset_email!)
    PasswordResetJob.perform_now(email: 'idontexist@example.com')
  end
end
