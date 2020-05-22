class AddLastLoginToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :last_login_ip, :string
    add_column :users, :last_login_time, :datetime
  end
end
