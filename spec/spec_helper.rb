require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.color = true
  config.add_formatter('RspecJunitFormatter', 'rspec.xml')
end

at_exit { ChefSpec::Coverage.report! }
