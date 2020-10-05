class AddAboutsToImages < ActiveRecord::Migration[6.0]
  def change
    add_reference :images, :abouts, index: true, foreign_key: true
  end
end
