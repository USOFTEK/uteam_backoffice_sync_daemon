require "database_cleaner"
require "faker"
require "factory_girl"
require "shoulda/matchers"

$env = :test
require_relative "../lib/daemon"
[File.join(File.dirname(__FILE__), ".."), PATH_TO_TRACKER].each do |path|
  system "cd #{path} && RACK_ENV=test rake db:setup &&
  RACK_ENV=test rake db:migrate && RACK_ENV=test rake db:seed"
end

Daemon.connect_to_dbs
#
# RSpec.configure do |config|
#   config.before(:suite) do
#     DatabaseCleaner.strategy = :truncation
#     DatabaseCleaner.clean_with :truncation
#     begin
#       DatabaseCleaner.start
#     ensure
#       DatabaseCleaner.clean
#     end
#   end
#
#   config.around(:each) do |example|
#     DatabaseCleaner.cleaning do
#       example.run
#     end
#   end
# end