#!/usr/bin/env ruby

require 'date'
require 'faraday'

domain = 'https://www.pensionwise.gov.uk'
pages = %w(
  /
  /6-steps-you-need-to-take
  /benefits
  /complaints
  /divorce
  /living-abroad
  /making-money-last
  /pension-complaints
  /pension-pot-options
  /pension-pot-value
  /pension-types
  /scams
  /shop-around
  /tax
  /work-out-income
)

conn = Faraday.new(domain)

for page in pages do
  puts page
  response = conn.get(page)

  unless response.status == 200
    raise "Status code was #{response.status}"
  end

  unless DateTime.parse(response.headers['expires']).to_time > Time.now
    raise "Expires at #{response.headers['expires']}"
  end
end
