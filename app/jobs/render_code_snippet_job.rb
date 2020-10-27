class RenderCodeSnippetJob < ApplicationJob
  queue_as :default

  def perform(code_snippet:)
    # render code snippet image using carbon-now-cli
  end
end