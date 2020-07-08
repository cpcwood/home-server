module Admin
  class SiteSettingsController < ApplicationController
    def update
      @notices = []
      @alerts = []
      update_settings(site_settings_update_params)
      upload_images(site_settings_images_params) if params[:image_upload].present?
      redirect_to(admin_site_settings_path, notice: @notices, alert: @alerts)
    end

    private

    def update_settings(permitted_params)
      permitted_params.each do |key, value|
        update_message(@site_settings.update(key.to_sym => value), key) if @site_settings.update_required?(key, value)
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

    def upload_images(permitted_params)
      update_message(@site_settings.header_image.attach(permitted_params[:header_image]), 'header_image') if permitted_params[:header_image].present?
    end

    def site_settings_images_params
      params.require(:image_upload).permit(:header_image)
    end
  end
end