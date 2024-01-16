require 'rspec'
require 'webmock/rspec'
require 'json'

require_relative "../lib/attrio"

Class.class_eval do
  def const_missing(name)
    Attrio::AttributesParser.cast_type(name) || super
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.disable_monkey_patching!
  config.warnings = true
  config.order = :random
  Kernel.srand config.seed
end
