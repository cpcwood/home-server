module Admin
  class CodeSnippetsController < ApplicationController
    def index
      @code_snippets = CodeSnippet.order(created_at: :desc)
    end

    def new
      @code_snippet = CodeSnippet.new
    end
  end
end