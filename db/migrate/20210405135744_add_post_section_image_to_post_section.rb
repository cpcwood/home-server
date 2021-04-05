class AddPostSectionImageToPostSection < ActiveRecord::Migration[6.1]
  def change
    add_reference :post_sections, :post_section_image, index: true, foreign_key: true
  end
end
