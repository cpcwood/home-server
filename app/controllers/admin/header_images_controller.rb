module Admin
  class HeaderImagesController < ImagesController
    def update
      @notices = []
      @alerts = []
      begin
        @image = HeaderImage.find_by(id: params[:id])
        update_image
      rescue StandardError => e
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      redirect_to(admin_images_path, notice: @notices, alert: @alerts)
    end

    private

    def permitted_params
      params.require(:header_image).permit(
        :x_loc,
        :y_loc,
        :image_file)
    end

    def reset_params
      params.require(:attachment).permit(:reset)
    end
  end
end