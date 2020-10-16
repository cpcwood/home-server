class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.timestamp :date_published, null: false
      t.string :overview, null: false
      t.text :text
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
