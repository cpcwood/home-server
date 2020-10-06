module AttachmentHelper
  def image_file_name(image:, default_name: nil, model_name: nil)
    if image&.image_file.attached?
      image.image_file.attachment.blob.filename
    else
      default_name ? default_name : "default #{"#{model_name} " if model_name}image"
    end
  end
end