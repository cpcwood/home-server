class RemoveXLocAndYLocFromProfileImages < ActiveRecord::Migration[6.0]
  def change
    remove_column :profile_images, :x_loc, :integer
    remove_column :profile_images, :y_loc, :integer
  end
end
