class RemoveMobileNumberFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :mobile_number, :text
  end
end
