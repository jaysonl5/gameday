# config/puma.rb

# Set the Rails environment
rails_env = ENV.fetch("RAILS_ENV") { "production" }
environment rails_env

# Set the directory where the app lives
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

# Bind to a Unix socket (for NGINX)
bind "unix:///home/ubuntu/gameday/tmp/sockets/puma.sock"

# Set PID and state file paths
pidfile "#{app_dir}/tmp/pids/puma.pid"
state_path "#{app_dir}/tmp/pids/puma.state"

# Logging
stdout_redirect "/home/ubuntu/gameday/log/puma.stdout.log", "/home/ubuntu/gameday/log/puma.stderr.log", true

# Puma workers and threads (tune based on your VPS size)
workers 0
threads 1, 6

# Daemonize (optional – can be managed via systemd instead)
# daemonize true

# Preload the app for better worker boot times
#preload_app!

# Allow Puma to be restarted by `rails restart` command
plugin :tmp_restart
