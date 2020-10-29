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
  end
end