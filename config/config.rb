require "i18n"
#activerecord
I18n.enforce_available_locales = false

ENVIR ||= "#{ ENV['ENVIR'] || "development" }".downcase.to_sym
p ENVIR


# # SETTINGS

# databases
DUMP_CURRENT_DB_NAME = "billing_track_development"

# Please set this up to normal work
# This shoud be look like tracker 'config/database.yml' file.
settings = {
    development: {
        path_to_tracker: "/var/www/cabinet/tracker/current",
        sql_user: "root",
        sql_pass: ""
    },
    staging: {
        path_to_tracker: "/var/www/cabinet/tracker/current",
        sql_user: "root",
        sql_pass: ""
    }
}
# # End SETTINGS

#paths
PATH_TO_TRACKER = settings[ENVIR][:path_to_tracker]
PATH_TO_TRACKER_MODELS = "#{PATH_TO_TRACKER}/app/models/*.rb"
PATH_TO_TRACKER_DB_YAML = "#{PATH_TO_TRACKER}/config/database.yml"

PATH_TO_CURRENT_DB_YAML = "#{File.dirname(__FILE__)}/database_cb.yml"

#credentials
SQL_USER = settings[ENVIR][:sql_user]
SQL_PASS = settings[ENVIR][:sql_pass]


# program logic

CONNECTION_POOL_SIZE = 20
USERS_LIMIT_PER_TRANSACTION = 1
