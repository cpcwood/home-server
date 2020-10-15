class DropImagesTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :images do |t|
      t.string :name
      t.string :link
      t.string :description
      t.string :image_type
      t.integer :x_loc, :default => 50
      t.integer :y_loc, :default => 50
      t.integer :x_dim
      t.integer :y_dim
      t.references :site_setting, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
