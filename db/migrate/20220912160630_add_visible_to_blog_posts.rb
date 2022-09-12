class AddVisibleToBlogPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :visible, :boolean, default: true, null: false
  end
end
