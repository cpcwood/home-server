module DefaultImageHelper
  DEFAULT_IMAGE_PATHS = {
    'header_image' => 'default_images/default_header_image.jpg',
    'about_image' => 'default_images/default_cover_image.jpg',
    'projects_image' => 'default_images/default_cover_image.jpg'
  }.freeze

  def image_path(image)
    image.attached? ? image : default_image_path(image.name)
  end

  def default_image_path(image_name)
    DEFAULT_IMAGE_PATHS[image_name]
  end
end