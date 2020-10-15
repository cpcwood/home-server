# == Schema Information
#
# Table name: site_settings
#
#  id                   :bigint           not null, primary key
#  header_text          :string
#  name                 :string
#  subtitle_text        :string
#  typed_header_enabled :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
FactoryBot.define do
  factory :site_setting, class: 'SiteSetting' do
    name { 'site name' }
    typed_header_enabled { 0 }
    header_text { 'test header text' }
    subtitle_text { 'test subtitle text' }

    factory :site_setting_with_images do
      header_image { create(:header_image) }
      cover_images do
        [
          create(:cover_image)
        ]
      end
    end
  end
end
