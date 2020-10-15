class UpdateAboutToImageReference < ActiveRecord::Migration[6.0]
  def change
    remove_reference :images, :abouts
    add_reference :images, :about, index: true, foreign_key: true
  end
end
