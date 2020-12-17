class GalleryImagesController < ApplicationController
  def index
    @gallery_images = GalleryImage.order(date_taken: :desc)
  end
end
