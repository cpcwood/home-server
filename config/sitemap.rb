# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = ENV.fetch('SITE_HOST') { "http://www.example.com" } 
SitemapGenerator.verbose = false

SitemapGenerator::Sitemap.create do
  add root_path
  add about_path
  add contact_path
  add posts_path
  Post.find_each do |post|
    add post_path(post), :lastmod => post.updated_at
  end
  add gallery_images_path
  add code_snippets_path
  CodeSnippet.find_each do |code_snippet|
    add code_snippet_path(code_snippet), :lastmod => code_snippet.updated_at
  end
  add projects_path
end
