class AddOtpLockoutToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :failed_otp_attempts, :integer, default: 0, null: false
    add_column :users, :otp_locked_until, :datetime
  end
end
