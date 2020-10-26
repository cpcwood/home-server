class CreateContactMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :contact_messages do |t|
      t.string :from, null: false
      t.string :email, null: false
      t.string :subject, null: false
      t.text :content, null: false
      t.timestamps
    end
  end
end
