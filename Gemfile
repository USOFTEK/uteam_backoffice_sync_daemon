source "https://rubygems.org/"

#add gems from tracker
begin
  DIR = File.dirname(__FILE__)
  file_path = DIR.scan(/^\/var\/www\/cabinet/i).empty? ?
                    File.expand_path(File.join(DIR, "..", "goliath", "tracker", "Gemfile")) :
                    "/var/www/cabinet/tracker/current/Gemfile"
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
