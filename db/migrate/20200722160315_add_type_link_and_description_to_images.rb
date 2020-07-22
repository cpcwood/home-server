class AddTypeLinkAndDescriptionToImages < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :image_type, :string
    add_column :images, :link, :string
    add_column :images, :description, :string
  end
end
