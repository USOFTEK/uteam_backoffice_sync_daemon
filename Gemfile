#add gems from tracker
begin
  dirname = File.dirname(__FILE__)
  gemfile = dirname.include?("/var/www/cabinet") ? "/var/www/cabinet/tracker/current/Gemfile" :
      File.join(dirname, "..", "Meta", "cabina", "tracker", "Gemfile")
  eval(IO.read(gemfile), binding)
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
