module AttachmentHelper
  IMAGE_NOT_FOUND = 'default_images/image_not_found.png'.freeze

  def image_path_helper(image_model:, variant: nil)
    if image_model&.image_file&.attached?
      return image_model.image_file.variant(image_model.variant_sizes[variant]) if variant
      return image_model.image_file
    end
    return image_model.default_image if image_model.respond_to?(:default_image)
    IMAGE_NOT_FOUND
  end

  def image_file_name(image:, default_name: nil, model_name: nil)
    return image.image_file.attachment.blob.filename if image&.image_file&.attached?
    default_name || "default #{"#{model_name} " if model_name}image"
  end

  def blob_url(image_model:)
    return unless image_model.image_file.attached?
  end
end