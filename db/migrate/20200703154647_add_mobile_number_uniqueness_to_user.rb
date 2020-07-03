class AddMobileNumberUniquenessToUser < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :mobile_number, unique: true
  end
end
