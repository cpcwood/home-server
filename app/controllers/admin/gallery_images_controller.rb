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
  end
end