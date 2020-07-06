class UsersController < ApplicationController
  def update
    update_username
    redirect_to(admin_user_settings_path, notice: 'User updated')
  end

  private

  def update_section?(permitted_params)
    permitted_params.values.all?{|v| !v.blank?}
  end

  def update_username
    if update_section?(username_update_params)
      @user.update(username_update_params) 
    else
      true
    end
  end

  def username_update_params
    params.require(:username).permit(:username, :username_confirmation)
  end
end
