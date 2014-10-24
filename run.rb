require "rubygems"
require "bundler/setup"
require "date"

require "em-synchrony"
require "em-synchrony/activerecord"
require "em-http-request"
require "active_support/all"
require 'em-synchrony/mysql2'

$env = "development"

require_relative 'lib/daemon'

abort("FAILED: Process is busy or previously exited with error. Quitting.") if File.exist?("LOCK")

# File.new("LOCK", "w").close


Daemon.sync_to_tracker


# File.delete "LOCK"