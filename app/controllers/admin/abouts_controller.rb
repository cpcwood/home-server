module Admin
  class AboutsController < AdminBaseController
    def edit
      @about = About.first
    end
  end
end