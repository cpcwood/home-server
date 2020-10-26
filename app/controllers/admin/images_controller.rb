module Admin
  class ImagesController < AdminBaseController
    def index
      @images = [@site_settings.header_image] + @site_settings.cover_images
      render layout: 'layouts/admin_dashboard'
    end

    private

    def update_image
      return @alerts.push('Image not found') unless @image
      return if image_reset?
      return if image_updated?
      @alerts.push(@image.errors.values.flatten.last)
    end

    def image_reset?
      return false unless reset_params[:reset] == '1'
      @image.reset_to_default
      @notices.push("#{@image.description.humanize} reset!")
      true
    end

    def image_updated?
      return false unless @image.update(permitted_params)
      @notices += @image.change_messages
      true
    end
  end
end