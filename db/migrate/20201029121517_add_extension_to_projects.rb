class AddExtensionToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :extension, :string
  end
end
