class AddMobileToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :mobile_number, :text
  end
end
