module AttachmentHelper
  IMAGE_NOT_FOUND = 'default_images/image_not_found.png'.freeze

  def image_path_helper(image_model:, variant: nil)
    if image_attached?(image_model)
      return image_model.image_file.variant(image_model.variant_sizes[variant]) if variant
      return image_model.image_file
    end
    default_image(image_model)
  end

  def image_file_name(image:, default_name: nil, model_name: nil)
    return image.image_file.attachment.blob.filename if image&.image_file&.attached?
    default_name || "default #{"#{model_name} " if model_name}image"
  end

  def image_attached?(image_model)
    return false unless image_model&.image_file&.attached?
    true
  end

  def default_image(image_model)
    return image_model.default_image if image_model.respond_to?(:default_image)
    IMAGE_NOT_FOUND
  end

  def fetch_image_url(image_model:, variant: nil)
    if image_attached?(image_model)
      if variant
        attachment = image_model.image_file.variant(image_model.variant_sizes[variant])
        return Rails.application.routes.url_helpers.rails_representation_url(attachment, only_path: true)
      else
        attachment = image_model.image_file
        return Rails.application.routes.url_helpers.rails_blob_path(attachment)
      end
    end
    default_image(image_model)
  end
end