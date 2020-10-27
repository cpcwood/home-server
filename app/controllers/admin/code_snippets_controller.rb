module Admin
  class CodeSnippetsController < ApplicationController
    def index
      @code_snippets = CodeSnippet.order(created_at: :desc)
      render layout: 'layouts/admin_dashboard'
    end

    def new
      @code_snippet = CodeSnippet.new
      render layout: 'layouts/admin_dashboard'
    end
  end
end