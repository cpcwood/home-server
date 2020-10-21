class GalleryImagesController < ApplicationController
  def index
    @gallery_images = GalleryImage.order(created_at: :desc)
  end
end
