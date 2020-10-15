module Admin
  class SiteSettingsController < AdminBaseController
    def index; end

    def update
      @notices = []
      @alerts = []
      begin
        update_settings
      rescue StandardError => e
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      redirect_to(admin_site_settings_path, notice: @notices, alert: @alerts)
    end

    private

    def permitted_params
      params.require(:site_setting).permit(
        :name,
        :header_text,
        :subtitle_text,
        :typed_header_enabled)
    end

    def update_settings
      if @site_settings.update(permitted_params)
        @notices += @site_settings.change_messages
      else
        @alerts.push(@site_settings.errors.values.flatten.last)
      end
    end
  end
end