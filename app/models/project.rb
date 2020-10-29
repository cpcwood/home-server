# == Schema Information
#
# Table name: projects
#
#  id            :bigint           not null, primary key
#  date          :datetime         not null
#  extension     :string
#  github_link   :string
#  overview      :text
#  site_link     :string
#  snippet       :text
#  title         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  main_image_id :bigint
#
# Indexes
#
#  index_projects_on_main_image_id  (main_image_id)
#
# Foreign Keys
#
#  fk_rails_...  (main_image_id => project_images.id)
#
class Project < ApplicationRecord

  has_many :project_images, dependent: :destroy
  belongs_to :main_project_image, class_name: 'ProjectImage', foreign_key: :main_image_id

  validates :title,
            length: { minimum: 1, message: 'Title cannot be empty' }

  validates :date,
            timeliness: { message: 'Date format invalid' }

  validates :extension,
            allow_blank: true,
            format: { with: /\A[a-zA-Z0-9]+\z/, message: 'File extension invalid' }

  validates :github_link,
            url: { allow_blank: true, message: 'Github link is not valid' }

  validates :site_link,
            url: { allow_blank: true, message: 'Site link is not valid' }
end
