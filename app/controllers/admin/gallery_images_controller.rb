module Admin
  class GalleryImagesController < AdminBaseController
    def index
      @gallery_images = GalleryImage.order(created_at: :desc)
      render layout: 'layouts/admin_dashboard'
    end

    def new
      @gallery_image = GalleryImage.new
      render layout: 'layouts/admin_dashboard'
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
      render layout: 'layouts/admin_dashboard'
    end

    def update
      @notices = []
      @alerts = []
      begin
        @gallery_image = find_model
        return redirect_to(admin_gallery_images_path, alert: 'Gallery image not found') unless @gallery_image
        update_model(model: @gallery_image, success_message: 'Gallery image updated')
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
            selector_id: 'admin-gallery-images-edit-form',
            form_partial: 'admin/gallery_images/edit_form',
            model: { gallery_image: @gallery_image }
          },
          formats: [:js])
        flash[:alert] = nil
      else
        redirect_to(admin_gallery_images_path, notice: @notices)
      end
    end

    def destroy
      @notices = []
      @alerts = []
      begin
        @gallery_image = find_model
        return redirect_to(admin_gallery_images_path, alert: 'Gallery image not found') unless @gallery_image
        @gallery_image.destroy
        @notices.push('Gallery image removed')
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      redirect_to(admin_gallery_images_path, notice: @notices, alert: @alerts)
    end

    private

    def permitted_params
      params.require(:gallery_image).permit(
        :image_file,
        :title,
        :date_taken,
        :latitude,
        :longitude)
    end

    def update_model(model:, success_message:)
      if model.update(permitted_params)
        @notices.push(success_message)
      else
        @alerts.push(model.errors.messages.to_a.flatten.last)
      end
    end

    def find_model
      GalleryImage.find_by(id: params[:id])
    end
  end
end