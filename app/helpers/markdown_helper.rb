module MarkdownHelper
  require 'redcarpet'

  class HTML < Redcarpet::Render::HTML; end

  def markdown_admin(text)
    render_options = {
      hard_wrap: true,
      link_attributes: {
        rel: 'nofollow'
      }
    }

    extensions = {
      autolink: true,
      fenced_code_blocks: true,
      lax_spacing: true,
      no_intra_emphasis: true,
      strikethrough: true,
      superscript: true,
      tables: true,
      underline: true
    }

    renderer = HTML.new(render_options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    html = markdown.render(text).html_safe
    encapsulate_markdown(html)
  end

  def encapsulate_markdown(html)
    %(<div class="markdown">#{html}</div>)
  end
end