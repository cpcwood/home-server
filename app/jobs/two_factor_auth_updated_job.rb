class TwoFactorAuthUpdatedJob < ApplicationJob
  queue_as :default

  def perform(user:)
    user.send_two_factor_auth_updated_email!
  end
end
