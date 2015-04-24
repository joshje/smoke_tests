require_relative 'environment'

class Production < Environment
  run './bin/production_cache_test.rb'
  run "./bin/output_document_test.rb #{ENV['OUTPUT_DOCUMENT_PRODUCTION_DOMAIN']}"
end
