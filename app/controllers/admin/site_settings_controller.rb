module Admin
  class SiteSettingsController < ApplicationController
    def update
      @notices = []
      @alerts = []
      update_settings(site_settings_update_params)
      upload_images(site_settings_images_params)
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
      return reset_header_image if permitted_params[:header_image_reset] == '1'
      return if permitted_params[:header_image].blank?
      image_path = permitted_params[:header_image].tempfile.path
      return @alerts.push('Header image invalid, please upload a jpeg or png file!') unless SiteSetting.image_valid?(image_path)
      modified_image = SiteSetting.resize_header_image(image_path: image_path, x_dim: 2560, y_dim: 300)
      filename = permitted_params[:header_image].original_filename
      content_type = permitted_params[:header_image].content_type
      result = @site_settings.header_image.attach(
        io: File.open(modified_image),
        filename: filename,
        content_type: content_type
      )
      update_message(result, 'header_image')
    end

    def site_settings_images_params
      params.require(:image_upload).permit(:header_image, :header_image_reset)
    end

    def reset_header_image
      @site_settings.header_image.purge
      @site_settings.header_image.destroy
      @notices.push('Header image reset!')
    end
  end
end