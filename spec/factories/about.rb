FactoryBot.define do
  factory :about, class: 'About' do
    name { 'about name' }
    about_me { 'test about me' }
    linkedin_link { 'https://linkedin.com' }
    github_link { 'https://github.com' }
  end
end