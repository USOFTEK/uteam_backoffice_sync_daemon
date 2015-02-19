require "rubygems"
require "bundler/setup"
require "date"
require "mongoid"
require "mongoid-locker"
require "active_support/all"

abort("FAILED: Process is busy or previously exited with error. Quitting.") if File.exist?("LOCK")

$env = "development"

# Require models
Dir.glob("#{File.dirname(__FILE__)}/models/*.rb").each { |model| require model }

Mongoid.load!(File.expand_path("config/mongo.yml", File.dirname(__FILE__)), :development)

require_relative "lib/daemon"

# File.new("LOCK", "w").close

Daemon.sync_from_tracker

Daemon.sync_to_tracker

# File.delete "LOCK"