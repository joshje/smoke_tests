require_relative 'environment'

class Staging < Environment
  run './bin/staging_page_test.rb'
end
