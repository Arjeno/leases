# require 'active_support'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => File.dirname(__FILE__) + "/fixtures/db/retina_rails.sqlite3"
)

Dir["spec/support/**/*.rb"].each { |f| load f }

require 'rspec/rails'
require 'leases'
