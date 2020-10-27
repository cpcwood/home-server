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

    def create
      @notices = []
      @alerts = []
      begin
        @code_snippet = @user.code_snippets.new
        update_model(model: @code_snippet, success_message: 'Code snippet created')
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      if @alerts.any?
        flash[:alert] = @alerts
        render(
          partial: 'partials/form_replacement',
          locals: {
            selector_id: 'admin-code-snippets-new-form',
            form_partial: 'admin/code_snippets/new_form',
            model: { code_snippet: @code_snippet }
          },
          formats: [:js])
        flash[:alert] = nil
      else
        redirect_to(admin_code_snippets_path, notice: @notices)
      end
    end

    def edit
      @code_snippet = find_model(model: CodeSnippet)
      return redirect_to(admin_code_snippets_path, alert: 'Code snippet not found') unless @code_snippet
      render layout: 'layouts/admin_dashboard'
    end

    private

    def permitted_params
      params
        .require(:code_snippet)
        .permit(
          :title,
          :overview,
          :snippet,
          :text)
    end


    def find_model(model:)
      model.find_by(id: params[:id])
    end

    def update_model(model:, success_message:)
      if model.update(permitted_params)
        @notices.push(success_message)
      else
        @alerts.push(model.errors.values.flatten.last)
      end
    end
  end
end