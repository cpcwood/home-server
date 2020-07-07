module Admin
  class SiteSettingsController < ApplicationController
    def update
      @notices = []
      @alerts = []
      update_settings(site_settings_update_params)
      redirect_to(admin_site_settings_path, notice: @notices, alert: @alerts)
    end

    private

    def update_settings(permitted_params)
      permitted_params.each do |key, value|
        if @site_settings.update_required?(key, value)
          update_message(@site_settings.update(key.to_sym => value), key)
        end
      end
    end

    def update_message(result, key)
      if result
        @notices.push("Site #{key} updated!")
      else
        @alerts.push(@site_settings.errors.values.flatten.last)
        @site_settings.reload
      end
    end

    def site_settings_update_params
      params.require(:site_setting).permit(:name)
    end
  end
end