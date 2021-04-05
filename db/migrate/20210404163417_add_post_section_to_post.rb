class AddPostSectionToPost < ActiveRecord::Migration[6.1]
  def change
    add_reference :post_sections, :post, index: true, foreign_key: true
  end
end