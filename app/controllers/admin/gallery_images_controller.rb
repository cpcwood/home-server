module Admin
  class GalleryImagesController < AdminBaseController
    def index
      @gallery_images = GalleryImage.order(created_at: :desc)
    end

    def new
      @gallery_image = GalleryImage.new
    end

    def create
      @user.gallery_images.create(permitted_params)
      redirect_to(admin_gallery_images_path, notice: 'Gallery image created')
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
  end
end