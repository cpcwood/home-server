# == Schema Information
#
# Table name: project_images
#
#  id          :bigint           not null, primary key
#  description :string           default("project_image"), not null
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :bigint           not null
#
# Indexes
#
#  index_project_images_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class ProjectImage < Image
end
