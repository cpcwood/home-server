# == Schema Information
#
# Table name: post_section_images
#
#  id          :bigint           not null, primary key
#  description :string           default("post-image"), not null
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe PostSectionImage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
