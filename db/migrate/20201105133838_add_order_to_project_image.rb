class AddOrderToProjectImage < ActiveRecord::Migration[6.0]
  def change
    add_column :project_images, :order, :integer
  end
end
