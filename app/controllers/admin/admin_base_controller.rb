module Admin
  class AdminBaseController < ApplicationController
    before_action :check_admin_logged_in
  end
end