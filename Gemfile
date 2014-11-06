source "https://rubygems.org/"

#add gems from tracker
begin
  DIR = File.dirname(__FILE__)
  on_server = DIR.scan(/^\/var\/www\/cabinet/i).empty? ?
      "../goliath/tracker/Gemfile" :
      "../../tracker/current/Gemfile"
  file_path = File.expand_path(on_server, __FILE__)
  puts file_path
  eval(IO.read(file_path), binding)
rescue Errno::ENOENT
  p "Tracker gemfile can't be loaded"
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
