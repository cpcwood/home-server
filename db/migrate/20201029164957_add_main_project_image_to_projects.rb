class AddMainProjectImageToProjects < ActiveRecord::Migration[6.0]
  def change
    add_reference :projects, :main_image, foreign_key: { to_table: :project_images }
  end
end
