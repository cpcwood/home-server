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
        @project = Project.new
        update_model(model: @project, success_message: 'Project created')
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
        @project = find_model
        return redirect_to(admin_projects_path, alert: 'Project not found') unless @project
        update_model(model: @project, success_message: 'Project updated')
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

    def permitted_params
      params
        .require(:project)
        .permit(
          :title,
          :overview,
          :date,
          :github_link,
          :site_link,
          project_image_attributes: [:id, :image_file, :order, :_destroy])
    end

    def find_model
      Project.find_by(id: params[:id])
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