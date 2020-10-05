module Admin
  class HeaderImagesController < AdminBaseController
    def update
      @notices = []
      @alerts = []
      begin
        @image = HeaderImage.find_by(id: params[:id])
        process_image_update
      rescue => e
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      redirect_to(admin_images_path, notice: @notices, alert: @alerts)
    end

    private

    def image_params
      params.require(:cover_image).permit(
        :update,
        :reset,
        :x_loc,
        :y_loc)
    end

    def process_image_update
      return image_reset if image_params[:reset] == '1'
      update_image_attributes
      update_image_attachment
    end

    def image_reset
      @image.reset_to_default
      @notices.push("#{@image.description.humanize} reset!")
    end

    def update_image_attributes
      @image.x_loc = image_params[:x_loc]
      @image.y_loc = image_params[:y_loc]
      return unless @image.changed?
      update_message(result: @image.save, attribute: 'location')
    end

    def update_image_attachment
      return if image_params[:update].blank?
      result = @image.attach_image(image_params[:update])
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