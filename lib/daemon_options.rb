require_relative "../config/config"
require "yaml"
require "erb"

require "em-synchrony"
require "em-synchrony/activerecord"
require "em-http-request"
require "active_support/all"
require 'em-synchrony/mysql2'

module DaemonOptions

  def connect_to_dbs
    $env = $env.to_s
    error! unless connect_to_tracker && connect_to_current
  end

  private

  def connect_to_tracker
    db = YAML.load(ERB.new(File.read(PATH_TO_TRACKER_DB_YAML)).result)[$env]
    ActiveRecord::Base.establish_connection(db)
    Dir[PATH_TO_TRACKER_MODELS].each {|file| require file }
    true
  end

  def connect_to_current
    @current_conn = EM::Synchrony::ConnectionPool.new(:size => CONNECTION_POOL_SIZE) do
      ::Mysql2::EM::Client.new(YAML.load(File.read(PATH_TO_CURRENT_DB_YAML))[$env])
    end
    true
  end

  def error!
    raise StandardError, "Couldn't connect to databases"
  end
end