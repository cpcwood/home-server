FactoryBot.define do
  factory :image, class: "Image" do
    description { 'image description' }
    x_loc { 50 }
    y_loc { 50 }

    factory :profile_image, class: "ProfileImage" do
      description { 'profile_image' }
      about
    end

    factory :header_image, class: "HeaderImage" do
      description { 'header_image' }
      site_setting
    end

    factory :cover_image, class: "CoverImage" do
      description { 'cover_image' }
      site_setting
      link { 'http://example.com' }
    end
  end
end