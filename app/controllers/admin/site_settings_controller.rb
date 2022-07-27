module Admin
  class SiteSettingsController < AdminBaseController
    def index
      render layout: 'layouts/admin_dashboard'
    end

    def update
      @notices = []
      flash[:alert] = []

      begin
        update_settings
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        flash[:alert].push('Sorry, something went wrong!')
        flash[:alert].push(e.message)
      end

      if flash[:alert].any?
        render(partial: 'admin/site_settings/edit_form',
               status: :unprocessable_entity,
               locals: { site_settings: @site_settings })
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
        flash[:alert].push(@site_settings.errors.messages.to_a.flatten.last)
      end
    end
  end
end