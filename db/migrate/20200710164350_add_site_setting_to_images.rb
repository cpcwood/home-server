class AddSiteSettingToImages < ActiveRecord::Migration[6.0]
  def change
    add_reference :images, :site_settings, index: true, foreign_key: true
  end
end
