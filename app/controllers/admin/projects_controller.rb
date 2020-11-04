module Admin
  class ProjectsController < AdminBaseController
    def index
      @projects = Project.order(date: :desc)
      render layout: 'layouts/admin_dashboard'
    end

    def new
      @project = Project.new
      render layout: 'layouts/admin_dashboard'
    end

    def create
      @notices = []
      @alerts = []
      begin
        Project.transaction do
          @project = Project.new
          update_model(model: @project, success_message: 'Project created')
          create_project_images(project: @project)
        end
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      if @alerts.any?
        flash[:alert] = @alerts
        @project = Project.new(project_params)
        render(
          partial: 'partials/form_replacement',
          locals: {
            selector_id: 'admin-projects-new-form',
            form_partial: 'admin/projects/new_form',
            model: { project: @project }
          },
          formats: [:js])
        flash[:alert] = nil
      else
        redirect_to(admin_projects_path, notice: @notices)
      end
    end

    def edit
      @project = find_model
      return redirect_to(admin_projects_path, alert: 'Project not found') unless @project
      render layout: 'layouts/admin_dashboard'
    end

    def update
      @notices = []
      @alerts = []
      begin
        Project.transaction do
          @project = find_model
          return redirect_to(admin_projects_path, alert: 'Project not found') unless @project
          if render_code_snippet
            update_model(model: @project, success_message: 'Project updated')
            create_project_images(project: @project)
          end
        end
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      if @alerts.any?
        flash[:alert] = @alerts
        @project = find_model
        @project.assign_attributes(project_params)
        render(
          partial: 'partials/form_replacement',
          locals: {
            selector_id: 'admin-projects-edit-form',
            form_partial: 'admin/projects/edit_form',
            model: { project: @project }
          },
          formats: [:js])
        flash[:alert] = nil
      else
        redirect_to(admin_projects_path, notice: @notices)
      end
    end

    def destroy
      @notices = []
      @alerts = []
      begin
        @project = find_model
        return redirect_to(admin_projects_path, alert: 'Project not found') unless @project
        @project.destroy
        @notices.push('Project removed')
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      redirect_to(admin_projects_path, notice: @notices, alert: @alerts)
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
          project_images_attributes: [:id, :image_file, :_destroy, :title])
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
        @alerts.push(model.errors.values.flatten.last)
      end
    end

    def create_project_images(project:)
      return unless params.dig(:new_project_images, :image_files)
      new_project_images_params[:image_files].each do |image_param|
        next if ProjectImage.create(image_file: image_param, project: project)
        @alerts.push('Image upload error')
        raise(ActiveRecord::Rollback, 'Image upload error')
      end
    end

    def render_code_snippet
      return true unless params.dig(:snippet, :snippet) && params.dig(:snippet, :extension)
      if @project.render_code_snippet(snippet_params.to_h.symbolize_keys)
        @notices.push('Code snippet rendered')
        true
      else
        @alerts.push('Code snippet invalid')
        false
      end
    end
  end
end