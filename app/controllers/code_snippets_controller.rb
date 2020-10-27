class CodeSnippetsController < ApplicationController
  def index
    @code_snippets = CodeSnippet.order(modified_at: :desc)
  end
end