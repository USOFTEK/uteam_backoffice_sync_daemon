# # To use this daemon please refactor code below separated in comments block
# Path to tracker directory
tracker_dirpath = "/var/www/tracker"
# # END

# Debug method
def log_out message, type = :info
  puts "#{type.to_s.upcase}: [#{Time.now.to_s}][Gemfile] #{message}"
end

# Gemfile
source "https://rubygems.org/"

ruby "2.1.0"

#add gems from tracker
begin
  DIR = File.dirname(__FILE__)
  file_path = "#{tracker_dirpath.gsub(/\/(Gemfile)?$/i, "")}/Gemfile"
  log_out("Loading gemset from tracker. Path: [#{file_path}]")
  eval(IO.read(file_path), binding)
rescue Errno::ENOENT
  log_out("Unable to read Tracker Gemfile!", :error)
end

# Mysql2
gem "mysql2"


# ActiveRecord
gem "activerecord"

# ActiveSupport
gem "activesupport"

# EM
gem "eventmachine"

# Mongoid
gem "mongoid"

# MongoidLocker
gem "mongoid-locker"

gem "capistrano"
