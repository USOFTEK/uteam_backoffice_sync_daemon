require "database_cleaner"
require "faker"
require "factory_girl"
require "shoulda/matchers"

$env = :test
require_relative "../lib/daemon"
#
# RSpec.configure do |config|
#
# end