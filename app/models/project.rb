# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  date        :datetime         not null
#  extension   :string
#  github_link :string
#  overview    :text
#  site_link   :string
#  snippet     :text
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Project < ApplicationRecord
  validates :title,
            length: { minimum: 1, message: 'Title cannot be empty' }

  validates :date,
            timeliness: { message: 'Date format invalid' }

  validates :extension,
            allow_blank: true,
            format: { with: /\A[a-zA-Z0-9]+\z/, message: 'File extension invalid' }
end
