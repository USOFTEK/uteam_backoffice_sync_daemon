require_relative "daemon_options"

module Daemon
  extend DaemonOptions

  def self.archive_db db_name = nil
    system "mysqldump -u#{SQL_USER} -p#{SQL_PASS} #{CURRENT_DB_NAME} > dumps/#{db_name || Time.now.to_i}.sql"
  end

  def self.sync_to_tracker
    connect_to_dbs
  end
end