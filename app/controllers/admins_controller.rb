class AdminsController < ApplicationController
  before_action :check_admin_logged_in

  MESSAGES_PAGE_SIZE = 25

  def general
    render_dashboard
  end

  def notifications
    @page = [params[:page].to_i, 1].max
    @contact_messages = ContactMessage
                        .order(created_at: :desc, id: :desc)
                        .limit(MESSAGES_PAGE_SIZE)
                        .offset((@page - 1) * MESSAGES_PAGE_SIZE)
    @more_pages = ContactMessage.count > @page * MESSAGES_PAGE_SIZE
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