class RemoveSnippetAndExtensionFromProjects < ActiveRecord::Migration[6.0]
  def change
    remove_column :projects, :snippet, :text
    remove_column :projects, :extension, :string
  end
end
