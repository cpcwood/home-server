class ProfileImage < Image
  belongs_to :about

  def default_image
    'default_images/default_cover_image.jpg'
  end
end