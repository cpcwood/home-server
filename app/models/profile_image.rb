class ProfileImage < Image
  belongs_to :about

  X_DIM = 500
  Y_DIM = 500

  before_validation :set_defaults

  before_save :process_image_attachment

  def process_image_attachment
    image_upload = attachment_changes['image_file']
    attach_image(image_upload.attachable) if image_upload&.attachable.class == ActionDispatch::Http::UploadedFile
  end

  def set_defaults
    self.description ||= 'about-me-profile-image'
  end

  def default_image
    'default_images/image_not_found.png'
  end

  def x_dim
    X_DIM
  end

  def y_dim
    Y_DIM
  end
end