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