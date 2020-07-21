class AddLocationToImages < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :x_loc, :integer, :default => 50
    add_column :images, :y_loc, :integer, :default => 50
  end
end
