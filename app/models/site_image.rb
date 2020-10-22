class SiteImage < Image
  self.abstract_class = true
  
  belongs_to :site_setting

  DEFAULT_X_LOC = 50
  DEFAULT_Y_LOC = 50

  validates :x_loc,
            presence: true,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  validates :y_loc,
            presence: true,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def reset_to_default
    image_file.purge_later
    update(x_loc: DEFAULT_X_LOC, y_loc: DEFAULT_Y_LOC)
  end

  def custom_style
    "object-position: #{x_loc}% #{y_loc}%;" if x_loc != DEFAULT_X_LOC || y_loc != DEFAULT_Y_LOC
  end

  private

  def process_image(attached_image)
    Image.image_processing_pipeline(image_path: attached_image) do |pipeline| 
      pipeline.resize_to_fill(x_dim, y_dim, gravity: 'north-west')
    end
  end
end
