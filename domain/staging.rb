require_relative 'environment'

class Staging < Environment
  run './bin/staging_page_test.rb'
  run "./bin/output_document_test.rb #{ENV['OUTPUT_DOCUMENT_STAGING_DOMAIN']}"
end
