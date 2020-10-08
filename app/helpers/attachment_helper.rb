module AttachmentHelper
  IMAGE_NOT_FOUND = 'default_images/image_not_found.png'.freeze

  def image_path_helper(image)
    return image.image_file if image&.image_file&.attached?
    return image.default_image if image.respond_to?(:default_image)
    IMAGE_NOT_FOUND
  end

  def image_file_name(image:, default_name: nil, model_name: nil)
    return image.image_file.attachment.blob.filename if image&.image_file&.attached?
    default_name || "default #{"#{model_name} " if model_name}image"
  end
end