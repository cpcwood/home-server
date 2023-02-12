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

    def edit
      @gallery_image = find_model
      return redirect_to(admin_gallery_images_path, alert: 'Gallery image not found') unless @gallery_image

      render layout: 'layouts/admin_dashboard'
    end

    def create
      @notices = []
      flash[:alert] = []

      begin
        @gallery_image = @user.gallery_images.new
        update_model(model: @gallery_image, success_message: 'Gallery image created')
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        flash[:alert].push('Sorry, something went wrong!')
        flash[:alert].push(e.message)
      end

      if flash[:alert].any?
        render(:new,
               layout: 'layouts/admin_dashboard',
               status: :unprocessable_entity)
        flash[:alert] = nil
      else
        redirect_to(admin_gallery_images_path, notice: @notices)
      end
    end

    def update
      @notices = []
      flash[:alert] = []

      begin
        @gallery_image = find_model
        return redirect_to(admin_gallery_images_path, alert: 'Gallery image not found') unless @gallery_image

        update_model(model: @gallery_image, success_message: 'Gallery image updated')
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        flash[:alert].push('Sorry, something went wrong!')
        flash[:alert].push(e.message)
      end

      if flash[:alert].any?
        render(:edit,
               layout: 'layouts/admin_dashboard',
               status: :unprocessable_entity)
        flash[:alert] = nil
      else
        redirect_to(admin_gallery_images_path, notice: @notices)
      end
    end

    def destroy
      @notices = []
      flash[:alert] = []

      begin
        @gallery_image = find_model
        return redirect_to(admin_gallery_images_path, alert: 'Gallery image not found') unless @gallery_image

        @gallery_image.destroy
        @notices.push('Gallery image removed')
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        flash[:alert].push('Sorry, something went wrong!')
        flash[:alert].push(e.message)
      end

      redirect_to(admin_gallery_images_path, notice: @notices, alert: flash[:alert])
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
        flash[:alert].push(model.errors.messages.to_a.flatten.last)
      end
    end

    def find_model
      GalleryImage.find_by(id: params[:id])
    end
  end
end