require 'rails_helper'

RSpec.describe PasswordUpdatedJob, type: :job do
  let(:user) { User.create(username: 'admin', email: 'admin@example.com', password: 'Securepass1', mobile_number: '+447123456789') }

  it 'Password reset email sent' do
    expect(user).to receive(:send_password_updated_email!)
    PasswordUpdatedJob.perform_now(user: user)
  end
end
