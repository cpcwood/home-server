class AddDimensionsToImages < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :x_dim, :integer
    add_column :images, :y_dim, :integer
  end
end
