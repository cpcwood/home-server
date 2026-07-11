class AddTotpToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :otp_secret, :text
    add_column :users, :otp_consumed_timestep, :integer
  end
end
