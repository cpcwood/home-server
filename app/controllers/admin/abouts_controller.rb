module Admin
  class AboutsController < AdminBaseController
    before_action :assign_abouts

    def edit; end

    def update
      @notices = []
      @alerts = []
      begin
        update_about
      rescue StandardError => e
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      redirect_to(edit_admin_about_path, notice: @notices, alert: @alerts)
    end

    private

    def assign_abouts
      @about = About.first
    end

    def permitted_params
      params.require(:about).permit(
        :name,
        :about_me,
        :linkedin_link,
        :github_link,
        profile_image_attributes: [:id, :image_file, :_destroy])
    end

    def update_about
      if @about.update(permitted_params)
        update_messages
      else
        @alerts.push(@about.errors.values.flatten.last)
      end
    end

    def update_messages
      @notices += @about.change_messages
      return unless permitted_params[:profile_image_attributes]
      @notices.push('Profile image removed') if permitted_params[:profile_image_attributes][:_destroy] == '1'
    end
  end
end