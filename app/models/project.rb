# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  date        :datetime         not null
#  github_link :string
#  overview    :text
#  site_link   :string
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Project < ApplicationRecord
  has_many :project_images, dependent: :destroy
  accepts_nested_attributes_for :project_images, allow_destroy: true
  validates_associated :project_images

  validates :title,
            length: { minimum: 1, message: 'Title cannot be empty' }

  validates :date,
            timeliness: { message: 'Date format invalid' }

  validates :github_link,
            url: { allow_blank: true, message: 'Github link is not valid' }

  validates :site_link,
            url: { allow_blank: true, message: 'Site link is not valid' }
end
