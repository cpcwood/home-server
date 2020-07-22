module Admin
  class SiteSettingsController < ApplicationController
    def index; end

    def update
      @notices = []
      @alerts = []
      update_settings(site_settings_params)
      redirect_to(admin_site_settings_path, notice: @notices, alert: @alerts)
    end

    private

    def site_settings_params
      params.require(:site_setting).permit(
        :name,
        :header_text,
        :subtitle_text,
        :typed_header_enabled)
    end

    def update_settings(permitted_params)
      permitted_params.each do |key, value|
        update_message(result: @site_settings.update(key.to_sym => value), key: key) if @site_settings.update_required?(attribute: key, value: value)
      end
    end

    def update_message(result:, key:)
      if result
        @notices.push("#{key.humanize} updated!")
      else
        @alerts.push(@site_settings.errors.values.flatten.last)
        @site_settings.reload
      end
    end
  end
end