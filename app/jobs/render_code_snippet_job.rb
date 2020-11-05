class RenderCodeSnippetJob < ApplicationJob
  queue_as :default

  def perform(model:, snippet:, extension:)
    start_line = 0
    end_line = 12

    RenderCodeSnippetService.render_and_attach_image(
      snippet_text: snippet,
      syntax_extension: extension,
      attachment: model.image_file,
      start_line: start_line,
      end_line: end_line)
  end
end