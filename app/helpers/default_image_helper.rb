module DefaultImageHelper
  DEFAULT_IMAGE_PATHS = {
    'header_image' => 'default_images/default_header_image.jpg',
    'about_image' => 'default_images/default_cover_image.jpg',
    'projects_image' => 'default_images/default_cover_image.jpg',
    'blog_image' => 'default_images/default_cover_image.jpg',
    'say_hello_image' => 'default_images/default_cover_image.jpg',
    'gallery_image' => 'default_images/default_cover_image.jpg',
    'contact_image' => 'default_images/default_cover_image.jpg',
    'image_not_found' => 'default_images/image_not_found.png'
  }.freeze

  def image_path_helper(image)
    if image&.image_file
      image.image_file.attached? ? image.image_file : default_image_path(image.name)
    else
      default_image_path('image_not_found')
    end
  end

  def default_image_path(image_name)
    image_path = DEFAULT_IMAGE_PATHS[image_name]
    return DEFAULT_IMAGE_PATHS['image_not_found'] unless image_path
    image_path
  end
end