module Admin
  class GalleryImagesController < AdminBaseController
    def index
      @gallery_images = GalleryImage.order(created_at: :desc)
    end

    def new
      @gallery_image = GalleryImage.new
    end
  end
end