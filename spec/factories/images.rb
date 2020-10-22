FactoryBot.define do
  factory :image, class: 'Image' do
    description { 'image_description' }

    factory :site_image, class: 'SiteImage' do
      x_loc { 50 }
      y_loc { 50 }
      site_setting
      
      factory :header_image, class: 'HeaderImage' do
        description { 'header_image' }
      end
  
      factory :cover_image, class: 'CoverImage' do
        description { 'cover_image' }
        link { 'http://example.com' }
      end
    end

    factory :profile_image, class: 'ProfileImage' do
      description { 'profile_image' }
      about
    end

    factory :gallery_image , class: 'GalleryImage'do
      description { 'gallery_image' }
      date_taken { DateTime.new(2020, 04, 19, 0, 0, 0) }
      latitude { 51.510357 }
      longitude { -0.116773 }
      user
    end
  end
end