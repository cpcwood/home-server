class RemoveXDimAndYDimFromCoverImages < ActiveRecord::Migration[6.0]
  def change
    remove_column :cover_images, :x_dim, :integer
    remove_column :cover_images, :y_dim, :integer
  end
end