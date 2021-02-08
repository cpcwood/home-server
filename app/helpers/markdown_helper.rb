module MarkdownHelper
  require 'rouge/plugins/redcarpet'

  class HTML < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def rouge_formatter(lexer)
      Rouge::Formatters::HTMLLegacy.new(css_class: "code-block #{lexer.tag}")
    end
  end

  def markdown_admin(text)
    text ||= ''
    render_options = {
      hard_wrap: true,
      link_attributes: {
        rel: 'nofollow',
        target: '_blank'
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
    html = markdown.render(text)
    encapsulate_markdown(html).html_safe
  end

  def markdown_code(code:, extension:)
    markdown_admin("```#{extension}\n#{code}\n```")
  end

  def encapsulate_markdown(html)
    %(<div class="markdown">#{html}</div>)
  end
end