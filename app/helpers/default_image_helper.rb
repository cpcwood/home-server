module DefaultImageHelper
  def image_path_helper(image)
    if image&.image_file
      image.image_file.attached? ? image.image_file : image.default_image
    else
      'default_images/image_not_found.png'
    end
  end
end