if Rails.env.production? 
  Sentry.init do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.breadcrumbs_logger = [:active_support_logger]

    config.traces_sampler = lambda do |sampling_context|
      env = sampling_context[:env]
      next 0.0 if env && env['PATH_INFO'] == '/up'

      name = sampling_context.dig(:transaction_context, :name)
      next 0.0 if name.to_s.start_with?('SidekiqAlive')

      0.001
    end
  end
end