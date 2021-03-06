module Admin
  class AboutsController < AdminBaseController
    before_action :assign_abouts

    def edit
      render layout: 'layouts/admin_dashboard'
    end

    def update
      @notices = []
      @alerts = []
      begin
        update_about
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      if @alerts.any?
        @about.assign_attributes(permitted_params)
        flash[:alert] = @alerts
        render(
          partial: 'partials/form_replacement',
          locals: {
            selector_id: 'admin-abouts-edit-form',
            form_partial: 'admin/abouts/edit_form',
            model: { about: @about }
          },
          formats: [:js])
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
        @alerts.push(@about.errors.messages.to_a.flatten.last)
      end
    end

    def update_messages
      @notices += @about.change_messages
      return unless permitted_params[:profile_image_attributes]
      @notices.push('Profile image removed') if permitted_params[:profile_image_attributes][:_destroy] == '1'
    end
  end
end