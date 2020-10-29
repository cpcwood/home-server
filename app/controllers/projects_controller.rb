class ProjectsController < ApplicationController
  def index
    @projects = Project.order(date: :desc)
  end
end
