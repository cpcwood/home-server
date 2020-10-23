class AddTitleToGalleryImage < ActiveRecord::Migration[6.0]
  def change
    add_column :gallery_images, :title, :string
  end
end
