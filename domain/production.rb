require_relative 'environment'

class Production < Environment
  run './bin/production_cache_test.rb'
end
