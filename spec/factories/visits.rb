FactoryBot.define do
  factory :visit do
    sequence(:visit_token) { |n| "visit-token-#{n}" }
    sequence(:visitor_token) { |n| "visitor-token-#{n}" }
    started_at { Time.zone.now }
    landing_page { 'https://cpcwood.com/blog' }
    referring_domain { 'duckduckgo.com' }
    country { 'United Kingdom' }
    city { 'London' }
    device_type { 'Desktop' }
    browser { 'Firefox' }
    os { 'GNU/Linux' }
  end
end
