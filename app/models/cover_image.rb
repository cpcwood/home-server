class CoverImage < Image
  belongs_to :site_setting

  def default_image
    'default_images/default_cover_image.jpg'
  end
end