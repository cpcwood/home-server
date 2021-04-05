class CreatePostSectionImages < ActiveRecord::Migration[6.1]
  def change
    create_table :post_section_images do |t|
      t.string :description, null: false, default: 'post-image'
      t.string :title
      t.references :post_section, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
