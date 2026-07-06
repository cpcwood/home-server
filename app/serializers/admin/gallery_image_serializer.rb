module Admin
  class GalleryImageSerializer < ::GalleryImageSerializer
    attribute :link_url do |gallery_image|
      Rails.application.routes.url_helpers.edit_admin_gallery_image_path(gallery_image)
    end
  end
end
