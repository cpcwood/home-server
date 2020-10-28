class RenderCodeSnippetJob < ApplicationJob
  queue_as :default

  def perform(code_snippet:)
    # load config
    start_line = 0
    end_line = 12

    # create temp text file
    RenderCodeSnippetService.render_and_attach_image(
      snippet_text: code_snippet.snippet,
      syntax_extension: code_snippet.extension,
      attachment: code_snippet.create_code_snippet_image.image_file)
  end
end