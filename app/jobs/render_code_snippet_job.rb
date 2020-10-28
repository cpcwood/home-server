class RenderCodeSnippetJob < ApplicationJob
  queue_as :default

  def perform(code_snippet:)
    start_line = 0
    end_line = 12

    RenderCodeSnippetService.render_and_attach_image(
      snippet_text: code_snippet.snippet,
      syntax_extension: code_snippet.extension,
      attachment: code_snippet.create_code_snippet_image.image_file,
      start_line: start_line,
      end_line: end_line)
  end
end