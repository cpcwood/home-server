module Admin
  class CoverImagesController < AdminBaseController
    def update
      @notices = []
      @alerts = []
      begin
        current_image = CoverImage.find_by(id: params[:id])
        update_image(image: current_image, permitted_params: image_params)
      rescue StandardError
        @alerts.push('Sorry, something went wrong!')
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

    def update_image(image:, permitted_params:)
      return image_reset(image) if permitted_params[:reset] == '1'
      update_image_positon(image: image, permitted_params: permitted_params)
      return if permitted_params[:update].blank?
      image_file_path = permitted_params[:update].tempfile.path
      return @alerts.push("#{image.description.humanize} invalid, please upload a jpeg or png file!") unless Image.valid?(image_file_path)
      modified_image = Image.resize(image_path: image_file_path, x_dim: image.x_dim, y_dim: image.y_dim)
      result = attach_new_image(new_image_path: modified_image.path, image: image, permitted_params: permitted_params)
      update_message(result: result, image: image)
    end

    def image_reset(image)
      image.reset_to_default
      @notices.push("#{image.description.humanize} reset!")
    end

    def update_image_positon(image:, permitted_params:)
      image.x_loc = permitted_params[:x_loc]
      image.y_loc = permitted_params[:y_loc]
      return unless image.changed?
      update_message(result: image.save, image: image, attribute: 'location')
    end

    def attach_new_image(new_image_path:, image:, permitted_params:)
      filename = permitted_params[:update].original_filename
      content_type = permitted_params[:update].content_type
      image.image_file.attach(
        io: File.open(new_image_path),
        filename: filename,
        content_type: content_type)
    end

    def update_message(result:, image:, attribute: nil)
      if result
        @notices.push("#{image.description.humanize}#{" #{attribute}" if attribute} updated!")
      else
        @alerts.push(image.errors.values.flatten.last)
      end
    end
  end
end