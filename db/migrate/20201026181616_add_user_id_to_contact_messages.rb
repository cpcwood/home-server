class AddUserIdToContactMessages < ActiveRecord::Migration[6.0]
  def change
    add_reference :contact_messages, :user, index: true, foreign_key: true
  end
end
