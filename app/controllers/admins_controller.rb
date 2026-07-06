class AdminsController < ApplicationController
  before_action :check_admin_logged_in

  def general
    render_dashboard
  end

  def notifications
    render_dashboard
  end

  def analytics
    @period = params[:period].presence_in(AnalyticsService::PERIODS.keys) || AnalyticsService::DEFAULT_PERIOD
    @metrics = AnalyticsService.metrics(@period)
    render_dashboard
  end

  private

  def render_dashboard
    render layout: 'layouts/admin_dashboard'
  end
end