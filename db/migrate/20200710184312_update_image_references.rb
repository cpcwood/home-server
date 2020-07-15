class UpdateImageReferences < ActiveRecord::Migration[6.0]
  def change
    remove_reference :images, :site_settings
    add_reference :images, :site_setting, index: true, foreign_key: true
  end
end
