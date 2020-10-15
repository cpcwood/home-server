class RemoveXDimAndYDimFromHeaderImages < ActiveRecord::Migration[6.0]
  def change
    remove_column :header_images, :x_dim, :integer
    remove_column :header_images, :y_dim, :integer
  end
end
