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

  def render_code_snippet(**kwargs)
    return false unless code_snippet_valid?(**kwargs)
    RenderCodeSnippetJob.perform_later(model: project_images.create, **kwargs)
    true
  end

  def self.all_with_images
    includes(:project_images).order('project_images.order ASC')
  end

  private

  def code_snippet_valid?(snippet:, extension:)
    return false unless snippet.is_a?(String)
    return false unless snippet.length > 0
    return false unless extension.is_a?(String)
    return false unless /\A[a-zA-Z0-9]+\z/.match?(extension)
    true
  end
end
