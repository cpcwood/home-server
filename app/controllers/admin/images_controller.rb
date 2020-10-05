module Admin
  class ImagesController < AdminBaseController
    def index
      @images = [@site_settings.header_image] + @site_settings.cover_images
    end
  end
end