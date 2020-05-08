class PasswordController < ApplicationController
  def forgotten_password
    render :forgotten_password
  end

  def send_reset_link
    redirect_to(:login, notice: 'If the submitted email is associated with an account, a password reset link will be sent')
  end
end
