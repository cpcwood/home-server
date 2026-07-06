module AnalyticsService
  PERIODS = {
    '7d' => 7.days,
    '30d' => 30.days,
    '90d' => 90.days,
    '12m' => 12.months
  }.freeze
  DEFAULT_PERIOD = '30d'.freeze
  TOP_LIMIT = 10

  class << self
    def metrics(period)
      scope = Visit.where(started_at: PERIODS.fetch(period, PERIODS[DEFAULT_PERIOD]).ago..)
      {
        visits_per_day: scope.group_by_day(:started_at).count,
        unique_visitors_per_day: scope.group_by_day(:started_at).distinct.count(:visitor_token),
        top_landing_pages: top(scope, :landing_page),
        top_referrers: top(scope, :referring_domain),
        top_countries: top(scope, :country),
        top_cities: top(scope, :city),
        device_breakdown: scope.group(:device_type).count.sort_by { |_, count| -count },
        browser_breakdown: scope.group(:browser).count.sort_by { |_, count| -count },
        os_breakdown: scope.group(:os).count.sort_by { |_, count| -count }
      }
    end

    private

    def top(scope, column)
      scope.where.not(column => [nil, '']).group(column).order(count_all: :desc).limit(TOP_LIMIT).count.to_a
    end
  end
end
