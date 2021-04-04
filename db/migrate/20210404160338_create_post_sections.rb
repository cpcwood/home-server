class CreatePostSections < ActiveRecord::Migration[6.1]
  def change
    create_table :post_sections do |t|
      t.text :text
      t.integer :order, null: false

      t.timestamps
    end
  end
end
