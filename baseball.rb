ENV["BASEBALL_ENV"] ||= 'production'

require 'active_record'
require 'csv'
require 'awesome_print'
Dir["lib/models/*"].each { |model_file| require_relative model_file }
require_relative "lib/calculator"
require_relative "lib/writer"

I18n.enforce_available_locales = false

db_config = {
  :adapter  => "sqlite3",
  :database => "db/baseball_#{ENV["BASEBALL_ENV"]}.db"
}
ActiveRecord::Base.establish_connection(db_config)
