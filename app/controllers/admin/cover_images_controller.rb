module Admin
  class CoverImagesController < ImagesController
    def update
      @notices = []
      @alerts = []
      begin
        @image = CoverImage.find_by(id: params[:id])
        update_image
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      redirect_to(admin_images_path, notice: @notices, alert: @alerts)
    end

    private

    def permitted_params
      params.require(:cover_image).permit(
        :x_loc,
        :y_loc,
        :image_file)
    end

    def reset_params
      params.require(:attachment).permit(:reset)
    end
  end
end