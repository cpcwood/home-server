class AddCurrentLoginToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :current_login_ip, :string
    add_column :users, :current_login_time, :datetime
  end
end
