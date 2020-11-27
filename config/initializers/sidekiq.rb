Sidekiq.configure_server do |config|
  db_num = (Rails.env == 'production' ? 1 : 0)
  config.redis = { url: "redis://#{ENV.fetch('REDIS_HOST') {'localhost'}}:6379/0", db: db_num }
end

Sidekiq.configure_client do |config|
  db_num = (Rails.env == 'production' ? 1 : 0)
  config.redis = { url: "redis://#{ENV.fetch('REDIS_HOST') {'localhost'}}:6379/0", db: db_num }
end