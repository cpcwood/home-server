FactoryBot.define do
  factory :site_setting, class: "SiteSetting" do
    name { 'site name' }
    typed_header_enabled { 0 }
    header_text { 'test header text' }
    subtitle_text { 'test subtitle text' }
  end
end