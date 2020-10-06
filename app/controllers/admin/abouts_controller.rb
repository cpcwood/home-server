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

    def attribute_params
      params.require(:about).permit(
        :name,
        :about_me)
    end

    def profile_image_params
      params.require(:profile_image).permit(
        :update,
        :reset)
    end

    def update_about
      if @about.update(attribute_params)
        changes = @about.previous_changes.keys - ['updated_at']
        changes.each{ |key| @notices.push("#{key.humanize} updated!") }
      else
        @alerts.push(@about.errors.values.flatten.last)
        @about.reload
      end
    end
  end
end