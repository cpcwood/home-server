class RemoveMobileNumberFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_index :users, :mobile_number, unique: true
    remove_column :users, :mobile_number, :text
  end
end
