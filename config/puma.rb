# vars
app_dir = File.expand_path('..', __dir__)
shared_dir = "#{app_dir}/shared"

# Specifies the `environment` that Puma will run in.
environment ENV.fetch('RAILS_ENV') { 'development' }

# pidfile and state
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"

# Threads for serving requests
threads ENV.fetch('PUMA_STARTING_THREADS') { 1 }, ENV.fetch('PUMA_MAX_THREADS') { 1 }

# Workers (cpu cores)
workers ENV.fetch('PUMA_WEB_CONCURRENCY') { 1 }
preload_app!

# Unix socket to for reverse proxy
# bind "unix://#{shared_dir}/sockets/puma.sock"
port 3000

# Debugging
debug

# Logging
# stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

activate_control_app

# on_worker_boot do
#   require "active_record"
#   ActiveRecord::Base.connection.disconnect! raise ActiveRecord::ConnectionNotEstablished
#   ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
# end
