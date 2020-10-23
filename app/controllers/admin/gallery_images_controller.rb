module Admin
  class GalleryImagesController < AdminBaseController
    def index
      @gallery_images = GalleryImage.order(created_at: :desc)
    end

    def new
      @gallery_image = GalleryImage.new
    end

    def create
      @notices = []
      @alerts = []
      begin
        @gallery_image = @user.gallery_images.new
        update_model(model: @gallery_image, success_message: 'Gallery image created')
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      if @alerts.any?
        flash[:alert] = @alerts
        render(
          partial: 'partials/form_replacement',
          locals: {
            selector_id: 'admin-gallery-images-new-form',
            form_partial: 'admin/gallery_images/new_form',
            model: { gallery_image: @gallery_image }
          },
          formats: [:js])
        flash[:alert] = nil
      else
        redirect_to(admin_gallery_images_path, notice: @notices)
      end
    end

    def edit
      @gallery_image = find_model
      return redirect_to(admin_gallery_images_path, alert: 'Gallery image not found') unless @gallery_image  
    end

    def update
      @notices = []
      @alerts = []
      @gallery_image = find_model
      return redirect_to(admin_gallery_images_path, alert: 'Gallery image not found') unless @gallery_image
      update_model(model: @gallery_image, success_message: 'Gallery image updated')
      redirect_to(admin_gallery_images_path, notice: @notices)
    end

    private

    def permitted_params
      params.require(:gallery_image).permit(
        :image_file,
        :description,
        :date_taken,
        :latitude,
        :longitude)
    end

    def update_model(model:, success_message:)
      if model.update(permitted_params)
        @notices.push(success_message)
      else
        @alerts.push(model.errors.values.flatten.last)
      end
    end

    def find_model
      GalleryImage.find_by(id: params[:id])
    end
  end
end