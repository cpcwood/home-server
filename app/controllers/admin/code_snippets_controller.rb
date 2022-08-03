module Admin
  class CodeSnippetsController < ApplicationController
    def new
      @code_snippet = CodeSnippet.new
      render layout: 'layouts/admin_dashboard'
    end

    def create
      @notices = []
      flash[:alert] = []

      begin
        @code_snippet = @user.code_snippets.new
        update_model(model: @code_snippet, success_message: 'Code snippet created')
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        flash[:alert].push('Sorry, something went wrong!')
        flash[:alert].push(e.message)
      end

      if flash[:alert].any?
        render(:new,
          layout: 'layouts/admin_dashboard',
          status: :unprocessable_entity)
        flash[:alert] = nil
      else
        redirect_to(code_snippets_path, notice: @notices)
      end
    end

    def edit
      @code_snippet = find_model
      return redirect_to(code_snippets_path, alert: 'Code snippet not found') unless @code_snippet
      render layout: 'layouts/admin_dashboard'
    end

    def update
      @notices = []
      flash[:alert] = []

      begin
        @code_snippet = find_model
        return redirect_to(code_snippets_path, alert: 'Code snippet not found') unless @code_snippet
        
        update_model(model: @code_snippet, success_message: 'Code snippet updated')
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        flash[:alert].push('Sorry, something went wrong!')
        flash[:alert].push(e.message)
      end

      if flash[:alert].any?
        render(:edit,
          layout: 'layouts/admin_dashboard',
          status: :unprocessable_entity)
        flash[:alert] = nil
      else
        redirect_to(code_snippets_path, notice: @notices)
      end
    end

    def destroy
      @notices = []
      flash[:alert] = []

      begin
        @code_snippet = find_model
        return redirect_to(code_snippets_path, alert: 'Code snippet not found') unless @code_snippet
        @code_snippet.destroy
        @notices.push('Code snippet removed')
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        flash[:alert].push('Sorry, something went wrong!')
        flash[:alert].push(e.message)
      end
      
      redirect_to(code_snippets_path, notice: @notices, alert: flash[:alert])
    end

    private

    def permitted_params
      params
        .require(:code_snippet)
        .permit(
          :title,
          :overview,
          :snippet,
          :extension,
          :text)
    end

    def find_model
      CodeSnippet.find_by(id: params[:id])
    end

    def update_model(model:, success_message:)
      if model.update(permitted_params)
        @notices.push(success_message)
      else
        flash[:alert].push(model.errors.messages.to_a.flatten.last)
      end
    end
  end
end