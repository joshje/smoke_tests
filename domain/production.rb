require_relative 'environment'

class Production < Environment
  run './bin/test_production.rb'
end
