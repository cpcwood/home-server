class AddExtensionToCodeSnippets < ActiveRecord::Migration[6.0]
  def change
    add_column :code_snippets, :extension, :string, null: false
  end
end
