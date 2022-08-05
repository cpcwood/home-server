module Admin
  class ProjectsController < AdminBaseController
    def new
      @project = Project.new
      render layout: 'layouts/admin_dashboard'
    end

    def create
      @notices = []
      flash[:alert] = []

      begin
        Project.transaction do
          @project = Project.new(project_params)

          update_model(model: @project, success_message: 'Project created')
          create_project_images(project: @project)
        end
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
        redirect_to(projects_path, notice: @notices)
      end
    end

    def edit
      @project = find_model
      return redirect_to(projects_path, alert: 'Project not found') unless @project
      render layout: 'layouts/admin_dashboard'
    end

    def update
      @notices = []
      flash[:alert] = []

      begin
        @project = find_model
        @project.assign_attributes(project_params)
        return redirect_to(projects_path, alert: 'Project not found') unless @project

        Project.transaction do
          if render_code_snippet
            update_model(model: @project, success_message: 'Project updated')
            create_project_images(project: @project)
          end
        end
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE:")
        e.backtrace.each do |loc|
          logger.error(loc)
        end
        flash[:alert].push('Sorry, something went wrong!')
        flash[:alert].push(e.message)
      end

      if flash[:alert].any?
        render(:edit,
          layout: 'layouts/admin_dashboard',
          status: :unprocessable_entity)
        flash[:alert] = nil
      else
        redirect_to(projects_path, notice: @notices)
      end
    end

    def destroy
      @notices = []
      flash[:alert] = []

      begin
        @project = find_model
        return redirect_to(projects_path, alert: 'Project not found') unless @project
        
        @project.destroy
        @notices.push('Project removed')
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        flash[:alert].push('Sorry, something went wrong!')
        flash[:alert].push(e.message)
      end

      redirect_to(projects_path, notice: @notices, alert: flash[:alert])
    end

    private

    def project_params
      params
        .require(:project)
        .permit(
          :title,
          :overview,
          :date,
          :github_link,
          :site_link,
          project_images_attributes: [:id, :image_file, :_destroy, :title, :order])
    end

    def snippet_params
      params
        .require(:snippet)
        .permit(
          :snippet,
          :extension)
    end

    def new_project_images_params
      params
        .require(:new_project_images)
        .permit(
          image_files: [])
    end

    def find_model
      Project.find_by(id: params[:id])
    end

    def update_model(model:, success_message:)
      if model.update(project_params)
        @notices.push(success_message)
      else
        flash[:alert].push(model.errors.messages.to_a.flatten.last)
      end
    end

    def create_project_images(project:)
      return unless params.dig(:new_project_images, :image_files)

      new_project_images_params[:image_files].reject(&:blank?).each do |image_param|
        next if ProjectImage.create(image_file: image_param, project: project)
        flash[:alert].push('Image upload error')
        raise(ActiveRecord::Rollback, 'Image upload error')
      end
    end

    def render_code_snippet
      snippet = params.dig(:snippet, :snippet)
      extension = params.dig(:snippet, :extension)
      return true unless snippet && extension
      return true unless snippet.length > 0 && extension.length > 0

      if @project.render_code_snippet(**snippet_params.to_h.symbolize_keys)
        @notices.push('Code snippet rendered')
        true
      else
        flash[:alert].push('Code snippet invalid')
        false
      end
    end
  end
end