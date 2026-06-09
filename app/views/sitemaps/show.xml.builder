xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.urlset xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  [root_url, about_url, contact_url, posts_url, gallery_images_url, code_snippets_url, projects_url].each do |loc|
    xml.url { xml.loc loc }
  end
  @posts.each do |post|
    xml.url do
      xml.loc post_url(post)
      xml.lastmod post.updated_at.iso8601
    end
  end
  @code_snippets.each do |code_snippet|
    xml.url do
      xml.loc code_snippet_url(code_snippet)
      xml.lastmod code_snippet.updated_at.iso8601
    end
  end
end
