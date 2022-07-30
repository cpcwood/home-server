class CreateGalleryImages < ActiveRecord::Migration[6.0]
  def change
    create_table :gallery_images do |t|
      t.string :description, null: false
      t.timestamp :date_taken
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.references :user, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
