class AddDefaultToPostSectionOrder < ActiveRecord::Migration[6.1]
  def change
    change_column :post_sections, :order, :integer, null: false, default: 0
  end
end
