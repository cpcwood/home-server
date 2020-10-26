FactoryBot.define do
  factory :about, class: 'About' do
    section_title { 'about me' }
    about_me { 'test about me' }
    linkedin_link { 'https://linkedin.com' }
    github_link { 'https://github.com' }
    name { 'test name' }
    location { 'london' }
    contact_email { 'admin@example.com' }
  end
end