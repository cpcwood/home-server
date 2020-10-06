module AttachmentHelper
  # rubocop:disable Lint/SafeNavigationChain
  def image_file_name(image:, default_name: nil, model_name: nil)
    return image.image_file.attachment.blob.filename if image&.image_file.attached?
    default_name || "default #{"#{model_name} " if model_name}image"
  end
  # rubocop:enable Lint/SafeNavigationChain
end