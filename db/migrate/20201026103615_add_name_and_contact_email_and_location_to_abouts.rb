class AddNameAndContactEmailAndLocationToAbouts < ActiveRecord::Migration[6.0]
  def change
    rename_column :abouts, :name, :section_title
    add_column :abouts, :name, :string, null: false, default: 'name'
    add_column :abouts, :location, :string, null: false, default: 'location'
    add_column :abouts, :contact_email, :string, null: false, default: 'admin@example.com'
    change_column :abouts, :name, :string, default: nil
    change_column :abouts, :location, :string, default: nil
    change_column :abouts, :contact_email, :string, default: nil
  end
end
