class RemoveMainProjectImageFromProjects < ActiveRecord::Migration[6.0]
  def change
    remove_reference :projects, :main_image, foreign_key: { to_table: :project_images }
  end
end
