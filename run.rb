require "rubygems"
require "bundler/setup"
require "date"

$env = "development"

require_relative 'lib/daemon'

abort("FAILED: Process is busy or previously exited with error. Quitting.") if File.exist?("LOCK")

# File.new("LOCK", "w").close


Daemon.sync_to_tracker


# File.delete "LOCK"