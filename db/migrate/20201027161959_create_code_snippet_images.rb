class CreateCodeSnippetImages < ActiveRecord::Migration[6.0]
  def change
    create_table :code_snippet_images do |t|
      t.string :description, null: false
      t.references :code_snippet, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
