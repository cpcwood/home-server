module DefaultImageHelper
  DEFAULT_IMAGE_PATHS = {
    'header_image' => 'default_images/default_header_image.jpg'
  }.freeze

  def default_image_path(image_name)
    DEFAULT_IMAGE_PATHS[image_name]
  end
end