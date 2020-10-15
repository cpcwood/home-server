class CreateHeaderImages < ActiveRecord::Migration[6.0]
  def change
    create_table :header_images do |t|
      t.string :description
      t.integer :x_loc, :default => 50
      t.integer :y_loc, :default => 50
      t.integer :x_dim
      t.integer :y_dim
      t.references :site_setting, index: true, foreign_key: true
      t.timestamps
    end
  end
end
