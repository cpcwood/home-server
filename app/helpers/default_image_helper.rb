module DefaultImageHelper
  IMAGE_NOT_FOUND = 'default_images/image_not_found.png'.freeze

  def image_path_helper(image)
    if image&.image_file
      image.image_file.attached? ? image.image_file : image.default_image
    else
      IMAGE_NOT_FOUND
    end
  end
end