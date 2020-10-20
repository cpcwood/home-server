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
      if @alerts.any?
        @site_settings.assign_attributes(permitted_params)
        flash[:alert] = @alerts
        render(
          partial: 'partials/form_replacement',
          locals: {
            selector_id: 'admin-site-settings-edit-form',
            form_partial: 'admin/site_settings/edit_form',
            model: { site_settings: @site_settings }
          },
          formats: [:js])
        flash[:alert] = nil
      else
        redirect_to(admin_site_settings_path, notice: @notices)
      end
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