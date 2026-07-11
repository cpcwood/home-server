module Admin
  class AdminBaseController < ApplicationController
    before_action :check_admin_logged_in

    private

    def verify_current_password
      @user.authenticate(params.dig(:current_password, :password).to_s)
    end
  end
end