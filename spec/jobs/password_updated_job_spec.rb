require 'rails_helper'

RSpec.describe PasswordUpdatedJob, type: :job do
  it 'Password reset email sent' do
    expect(@test_user).to receive(:send_password_updated_email!)
    PasswordUpdatedJob.perform_now(user: @test_user)
  end
end
