class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include UserFilters

  before_action :assign_user,
                :assign_site_setings

  private

  def assign_site_setings
    @site_settings = SiteSetting.first
    @header_image = @site_settings.header_image
    @footer_links = About.first.footer_links
  end
end
