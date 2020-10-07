class RemoveXDimAndYDimFromProfileImages < ActiveRecord::Migration[6.0]
  def change
    remove_column :profile_images, :x_dim, :integer
    remove_column :profile_images, :y_dim, :integer
  end
end
