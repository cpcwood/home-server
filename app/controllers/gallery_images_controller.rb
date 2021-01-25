class GalleryImagesController < ApplicationController
  PAGE_SIZE = 10

  def index
    @gallery_images = GalleryImage.order(date_taken: :desc).includes(image_file_attachment: :blob).limit(PAGE_SIZE).offset(calc_offset)
    respond_to do |format|
      format.html
      format.json { render json: GalleryImageSerializer.new(@gallery_images, {}).serializable_hash }
    end
  end

  private

  def calc_offset
    page_number = params['page'].to_i
    page_number > 0 ? ((page_number - 1) * PAGE_SIZE) : 0
  end
end
