
#activerecord
I18n.enforce_available_locales = false

#paths
PATH_TO_TRACKER = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "Meta", "cabina", "tracker"))
PATH_TO_TRACKER_MODELS = "#{PATH_TO_TRACKER}/app/models/*.rb"
PATH_TO_TRACKER_DB_YAML = "#{PATH_TO_TRACKER}/config/database.yml"

PATH_TO_CURRENT_DB_YAML = "#{File.dirname(__FILE__)}/database_cb.yml"

# databases
DUMP_CURRENT_DB_NAME = "billing_track_development"

#credentials
SQL_USER = "root"
SQL_PASS = "123456789"


# program logic

CONNECTION_POOL_SIZE = 20
USERS_LIMIT_PER_TRANSACTION = 1
