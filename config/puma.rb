# config/puma.rb - Works in both development and production

# Determine environment
rails_env = ENV.fetch("RAILS_ENV") { "development" }
environment rails_env

# Thread configuration
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Environment-specific configuration
if rails_env == "production"
  # PRODUCTION CONFIGURATION

  # App directory
  app_dir = File.expand_path("../..", __FILE__)

  # Bind to Unix socket for nginx
  bind "unix://#{app_dir}/tmp/sockets/puma.sock"

  # PID and state files
  pidfile "#{app_dir}/tmp/pids/puma.pid"
  state_path "#{app_dir}/tmp/pids/puma.state"

  # Logging
  stdout_redirect "#{app_dir}/log/puma.stdout.log",
                  "#{app_dir}/log/puma.stderr.log",
                  true

  # Workers and threads (tune based on server resources)
  workers ENV.fetch("WEB_CONCURRENCY") { 2 }
  threads 1, 6

  # Preload app for better performance
  preload_app!

  # Worker timeout
  worker_timeout 60

else
  # DEVELOPMENT CONFIGURATION

  # Bind to TCP port (accessible from browser)
  port ENV.fetch("PORT") { 3000 }

  # PID file
  pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

  # No workers in development (simpler debugging)
  # workers 0 is implicit

  # Longer timeout for debugging
  worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"
end

# Common configuration (both environments)
plugin :tmp_restart
