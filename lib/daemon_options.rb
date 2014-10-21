require_relative "../config/config"
require "yaml"
require "erb"

module DaemonOptions

  def connect_to_dbs
    error! unless connect_to_tracker && connect_to_current
  end

  private

  def connect_to_tracker
    db = YAML.load(ERB.new(File.read(PATH_TO_TRACKER_DB_YAML)).result)[$env]
    ActiveRecord::Base.establish_connection(db)
    Dir[PATH_TO_TRACKER_MODELS].each {|file| require file }
    puts User.all.count
    true
  end

  def connect_to_current
    puts "Connected to current"
    true
  end

  def error!
    raise StandardError, "Couldn't connect to databases"
  end
end