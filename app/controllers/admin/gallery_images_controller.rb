module Admin
  class GalleryImagesController < AdminBaseController
    def index
      @gallery_images = GalleryImage.order(created_at: :desc)
    end
  end
end