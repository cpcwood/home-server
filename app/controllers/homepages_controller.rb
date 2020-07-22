class HomepagesController < ApplicationController
  def index
    @cover_images = @site_settings.cover_images
  end
end
