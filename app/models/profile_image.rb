class ProfileImage < Image
  belongs_to :about

  X_DIM = 680
  Y_DIM = 680

  def default_image
    'default_images/default_cover_image.jpg'
  end

  def x_dim
    X_DIM
  end

  def y_dim
    Y_DIM
  end
end