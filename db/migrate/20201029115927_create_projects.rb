class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :overview
      t.timestamp :date, null: false
      t.string :github_link
      t.string :site_link
      t.text :snippet
      t.timestamps
    end
  end
end
