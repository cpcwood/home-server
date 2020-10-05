class HeaderImage < Image
  belongs_to :site_setting

  def default_image
    'default_images/default_header_image.jpg'
  end
end