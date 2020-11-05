class ProjectsController < ApplicationController
  def index
    @projects = Project.all_with_images
  end
end
