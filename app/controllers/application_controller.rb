class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include UserFilters

  before_action :assign_user,
                :assign_site_setings

  after_action :track_action

  protected

  def track_action
    ahoy.track("Ran action", request.path_parameters)
  end

  private

  def assign_site_setings
    @site_settings = SiteSetting.first
    @header_image = @site_settings.header_image
    @footer_links = About.first.footer_links
  end
end
