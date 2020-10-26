module Admin
  class UsersController < AdminBaseController
    def edit
      render layout: 'layouts/admin_dashboard'
    end

    def update
      return redirect_to(edit_admin_user_path(@user), alert: 'Enter current password to update details') unless verify_current_password
      @notices = []
      @alerts = []
      update_section(username_update_params, 'Username')
      update_section(email_update_params, 'Email address')
      update_section(password_update_params, 'Password')
      update_section(mobile_number_update_params, 'Mobile number')
      redirect_to(edit_admin_user_path(@user), notice: @notices, alert: @alerts)
    end

    private

    def verify_current_password
      current_password = current_password_params[:password]
      @user.authenticate(current_password)
    end

    def update_section(permitted_params, section_name)
      update_message(@user.update(permitted_params), section_name) if update_required?(permitted_params)
    end

    def update_required?(permitted_params)
      permitted_params.values.any?(&:present?)
    end

    def update_message(result, section_name)
      if result
        @notices.push("#{section_name} updated!")
      else
        @alerts.push(@user.errors.values.flatten.last)
        @user.reload
      end
    end

    def current_password_params
      params.require(:current_password).permit(:password)
    end

    def username_update_params
      params.require(:username).permit(:username, :username_confirmation)
    end

    def email_update_params
      params.require(:email).permit(:email, :email_confirmation)
    end

    def password_update_params
      params.require(:password).permit(:password, :password_confirmation)
    end

    def mobile_number_update_params
      params.require(:mobile_number).permit(:mobile_number, :mobile_number_confirmation)
    end
  end
end