module Admin
  class ImagesController < AdminBaseController
    def index
      @images = [@site_settings.header_image] + @site_settings.cover_images
    end

    private

    def process_image_update
      return image_reset if attachment_params[:reset] == '1'
      update_image_attributes
      update_image_attachment
    end

    def image_reset
      @image.reset_to_default
      @notices.push("#{@image.description.humanize} reset!")
    end

    def update_image_attributes
      @image.assign_attributes(model_params)
      return unless @image.changed?
      update_message(result: @image.save, attribute: 'location')
    end

    def update_image_attachment
      return if attachment_params[:update].blank?
      result = @image.attach_image(attachment_params[:update])
      update_message(result: result)
    end

    def update_message(result:, attribute: nil)
      if result
        @notices.push("#{@image.description.humanize}#{" #{attribute}" if attribute} updated!")
      else
        @alerts.push(@image.errors.values.flatten.last)
      end
    end
  end
end