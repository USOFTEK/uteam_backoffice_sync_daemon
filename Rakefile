require "rubygems"
require "active_record"
require "digest/md5"
require "yaml"
require "erb"
require "faker"
require "active_support/all"
require "database_cleaner"

require_relative "config/config"

# helpers
def copy_billing_db_config
  YAML.load(ERB.new(File.read("#{File.dirname(__FILE__)}/config/database_cb.yml")).result)
end

def tracker_db_config
	YAML.load(ERB.new(File.read(PATH_TO_TRACKER_DB_YAML)).result)
end

def with_rescue &block
	begin
		block.call if block_given?
	rescue => e
		puts(e)
	end
end

ENV["RACK_ENV"] ||= "development"
ENV["DB_CONFIG"] ||= "copy_billing"

# Database namespace
namespace(:db) do
	desc("Connect to DB")
	task(:connect) do
		with_rescue {
			configuration = send("#{ENV["DB_CONFIG"]}_db_config")
			ActiveRecord::Base.remove_connection
			ActiveRecord::Base.establish_connection(configuration[ENV["RACK_ENV"].downcase])
		}
	end

	desc("creates and migrates your database")
	task(:setup) do
		Rake::Task["db:create"].invoke
		with_rescue {
			configuration = send("#{ENV["DB_CONFIG"]}_db_config")
			configuration.each { |env,config|
				puts("Setting up database for: #{env}")
				system("RACK_ENV=#{env} DB_CONFIG=#{ENV["DB_CONFIG"]} rake db:migrate", out: $stdout, err: :out)
			}
		}
	end

  desc("migrate database")
  task(:migrate => ["db:connect"]) do
    ENV["VERSION"] ||= nil
    ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths, ENV["VERSION"])
  end

  desc "Drop databases"
  task(:drop) do
		with_rescue {
			configuration = send("#{ENV["DB_CONFIG"]}_db_config")
			configuration.each { |env,config|
				password = config["password"] rescue nil
				password = " -p#{password}" unless password.nil?
				system("mysqladmin --user=#{config["username"]}#{password} -f drop #{config["database"]}", out: $stdout, err: :out)
			}
		}
  end

  desc "Create databases"
	task(:create) do
		with_rescue {
			configuration = send("#{ENV["DB_CONFIG"]}_db_config")
			configuration.each { |env,config|
				password = config["password"] rescue nil
				password = " -p#{password}" unless password.nil?
				system("mysql --user=#{config["username"]}#{password} -e 'create DATABASE #{config["database"]} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci '", out: $stdout, err: :out)
			}
		}
  end

  desc("Check for pending migrations")
  task(:abort_if_pending_migrations) do
    abort("Run `rake db:migrate` to update database!") if ActiveRecord::Migrator.open(ActiveRecord::Migrator.migrations_paths).pending_migrations.any?
  end

  desc("Clean database")
  task(:clean => ["db:connect"]) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  desc("Load seeds")
  task(:seed => ["db:connect"]) do
    ENV["password"] ||= "my_temp_password"
    Rake::Task["db:abort_if_pending_migrations"].invoke
    # Init connection
    with_rescue {
    	configuration = send("#{ENV["DB_CONFIG"]}_db_config")
			DB = Mysql2::Client.new(configuration[ENV["RACK_ENV"].downcase])
    	require "#{File.dirname(__FILE__)}/db/seeds"
    }
  end

end

# Testing
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new("spec")

task :default => ["db:abort_if_pending_migrations", :spec]
