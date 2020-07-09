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

    def site_settings_update_params
      params.require(:site_setting).permit(:name)
    end

    def site_settings_images_params
      params.require(:image_upload).permit(
        :header_image,
        :header_image_reset,
        :about_image,
        :about_image_reset
      )
    end

    def update_settings(permitted_params)
      permitted_params.each do |key, value|
        update_message(@site_settings.update(key.to_sym => value), key) if @site_settings.update_required?(key, value)
      end
    end

    def update_message(result, key)
      if result
        @notices.push("#{key.humanize} updated!")
      else
        @alerts.push(@site_settings.errors.values.flatten.last)
        @site_settings.reload
      end
    end

    def upload_images(permitted_params)
      update_image(image_name: 'header_image', x_dim: 2560, y_dim: 300, permitted_params: permitted_params)
      update_image(image_name: 'about_image', x_dim: 1450, y_dim: 680, permitted_params: permitted_params)
    end

    def update_image(image_name:, x_dim:, y_dim:, permitted_params:)
      return image_reset(image_name) if permitted_params["#{image_name}_reset"] == '1'
      return if permitted_params[image_name].blank?
      image_path = permitted_params[image_name].tempfile.path
      return @alerts.push("#{image_name.humanize} invalid, please upload a jpeg or png file!") unless SiteSetting.image_valid?(image_path)
      modified_image = SiteSetting.resize_image(image_path: image_path, x_dim: x_dim, y_dim: y_dim)
      result = attach_image(image_path: modified_image.path, image_name: image_name, permitted_params: permitted_params)
      update_message(result, image_name)
    end

    def image_reset(image_name)
      @site_settings.send(image_name).purge
      @notices.push("#{image_name.humanize} reset!")
    end

    def attach_image(image_path:, image_name:, permitted_params:)
      filename = permitted_params[image_name].original_filename
      content_type = permitted_params[image_name].content_type
      @site_settings.send(image_name)
                    .attach(
                      io: File.open(image_path),
                      filename: filename,
                      content_type: content_type
                    )
    end
  end
end