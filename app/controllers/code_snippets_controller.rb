class CodeSnippetsController < ApplicationController
  def index
    @code_snippets = CodeSnippet.order(created_at: :desc)
  end

  def show
    @code_snippet = CodeSnippet.find_by(id: sanitize(params[:id]))
    redirect_to(code_snippets_path, alert: 'Code snippet not found') unless @code_snippet
  end

  private

  def sanitize(string)
    ActiveRecord::Base.sanitize_sql(string) unless string.nil?
  end
end