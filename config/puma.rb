# vars
app_dir = File.expand_path('..', __dir__)
shared_dir = "#{app_dir}/shared"

# Specifies the `environment` that Puma will run in.
environment ENV.fetch('RAILS_ENV') { 'development' }

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
#
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

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
port  ENV.fetch("PORT") { 5000 }

# Debugging
debug

# Redirect logging
# stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

activate_control_app

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart