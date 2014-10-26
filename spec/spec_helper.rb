ENV["BASEBALL_ENV"] = "test"
require_relative "../baseball"
require 'database_cleaner'

RSpec.configure do |config|
  config.order = "random"
  config.before(:all) do
    DatabaseCleaner.clean_with :truncation
  end
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
