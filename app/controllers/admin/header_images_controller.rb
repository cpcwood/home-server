module Admin
  class HeaderImagesController < ImagesController
    def update
      @notices = []
      @alerts = []
      begin
        @image = HeaderImage.find_by(id: params[:id])
        process_image_update
      rescue StandardError => e
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      redirect_to(admin_images_path, notice: @notices, alert: @alerts)
    end

    private

    def model_params
      params.require(:header_image).permit(
        :x_loc,
        :y_loc)
    end

    def attachment_params
      params.require(:header_image).permit(
        :update,
        :reset)
    end
  end
end