ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

# Load .env file immediately before anything else runs
# This ensures ENV vars are available when initializers run
if File.exist?(File.expand_path("../.env.#{ENV['RAILS_ENV'] || 'development'}", __dir__))
  require 'dotenv'
  Dotenv.load(File.expand_path("../.env.#{ENV['RAILS_ENV'] || 'development'}", __dir__))
end

require "bootsnap/setup" # Speed up boot time by caching expensive operations.
