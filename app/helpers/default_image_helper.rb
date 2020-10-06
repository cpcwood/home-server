module DefaultImageHelper
  DEFAULT_IMAGE_PATH = 'default_images/image_not_found.png'

  def image_path_helper(image)
    if image&.image_file
      image.image_file.attached? ? image.image_file : image.default_image
    else
      DEFAULT_IMAGE_PATH
    end
  end
end