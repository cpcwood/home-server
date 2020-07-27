class AddTypedHeaderSettingsToSiteSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :site_settings, :typed_header_enabled, :boolean
    add_column :site_settings, :header_text, :string
    add_column :site_settings, :subtitle_text, :string
  end
end
