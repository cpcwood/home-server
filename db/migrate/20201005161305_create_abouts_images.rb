class CreateAboutsImages < ActiveRecord::Migration[6.0]
  def change
    create_table :abouts_images do |t|
      t.string :link
      t.string :description
      t.integer :x_loc, :default => 50
      t.integer :y_loc, :default => 50
      t.integer :x_dim
      t.integer :y_dim
      t.references :about, index: true, foreign_key: true
    end
  end
end
