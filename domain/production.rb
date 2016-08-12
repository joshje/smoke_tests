require_relative 'environment'

class Production < Environment
  run "./bin/pension_guidance_test.rb #{ENV['PENSION_GUIDANCE_PRODUCTION_DOMAIN']}"
  run "./bin/cab_locator_test.rb #{ENV['PENSION_GUIDANCE_PRODUCTION_DOMAIN']}"
  run "./bin/output_document_test.rb #{ENV['OUTPUT_DOCUMENT_PRODUCTION_DOMAIN']}"
  run "./bin/twilio_redirect_test.rb #{ENV['TWILIO_REDIRECT_PRODUCTION_DOMAIN']}"
end
