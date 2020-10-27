class CreateCodeSnippets < ActiveRecord::Migration[6.0]
  def change
    create_table :code_snippets do |t|
      t.string :title, null: false
      t.string :overview, null: false
      t.text :snippet, null: false
      t.text :text
      t.references :user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
