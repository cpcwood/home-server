module Admin
  class AboutsController < AdminBaseController
    before_action :assign_abouts

    def edit
      render layout: 'layouts/admin_dashboard'
    end

    def update
      @notices = []
      flash[:alert] = []

      begin
        update_about
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        flash[:alert].push('Sorry, something went wrong!')
        flash[:alert].push(e.message)
      end

      if flash[:alert].any?
        render(partial: 'admin/abouts/edit_form',
               status: :unprocessable_entity,
               locals: {
                 about: @about
               })
        flash[:alert] = nil
      else
        redirect_to(edit_admin_about_path, notice: @notices)
      end
    end

    private

    def assign_abouts
      @about = About.first
    end

    def permitted_params
      params.require(:about).permit(
        :section_title,
        :about_me,
        :linkedin_link,
        :github_link,
        :name,
        :location,
        :contact_email,
        profile_image_attributes: [:id, :image_file, :_destroy])
    end

    def update_about
      if @about.update(permitted_params)
        update_messages
      else
        flash[:alert].push(@about.errors.messages.to_a.flatten.last)
      end
    end

    def update_messages
      @notices += @about.change_messages
      return unless permitted_params[:profile_image_attributes]
      @notices.push('Profile image removed') if permitted_params[:profile_image_attributes][:_destroy] == '1'
    end
  end
end