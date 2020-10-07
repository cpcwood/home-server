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
        profile_image_attributes: [:id, :image_file, :_destroy, :name, :file])
    end

    def update_about
      if @about.update(permitted_params)
        changes = @about.previous_changes.keys - ['updated_at']
        changes.each{ |key| @notices.push("#{key.humanize} updated!") }
        profile_image_messages
      else
        @alerts.push(@about.errors.values.flatten.last)
        @about.reload
      end
    end

    def profile_image_messages
      return unless permitted_params[:profile_image_attributes]
      return @notices.push('Profile image removed') if permitted_params[:profile_image_attributes][:_destroy] == '1'
      @notices.push('Profile image updated') if @about.profile_image.previous_changes.any? || @about.profile_image.image_file.attachment.blob.previous_changes.any?
    end
  end
end