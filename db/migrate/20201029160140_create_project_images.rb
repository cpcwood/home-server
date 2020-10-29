class CreateProjectImages < ActiveRecord::Migration[6.0]
  def change
    create_table :project_images do |t|
      t.string :description, null: false, default: 'project_image'
      t.string :title
      t.references :project, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
