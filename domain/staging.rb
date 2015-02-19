require_relative 'environment'

class Staging < Environment
  run './bin/test_staging.rb'
end
