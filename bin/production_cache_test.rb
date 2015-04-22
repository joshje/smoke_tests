#!/usr/bin/env ruby

require 'bundler/setup'
require 'date'
require 'faraday'

domain = 'https://www.pensionwise.gov.uk'
pages = %w(
  /
  /6-steps-you-need-to-take
  /already-bought-annuity
  /appointments
  /benefits
  /contact
  /cookies
  /cymraeg
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
  /when-you-die
  /work-out-income
)

puts ">> Checking at #{Time.now}"

conn = Faraday.new(domain)

for page in pages do
  puts page
  response = conn.get(page)

  unless DateTime.parse(response.headers['expires']).to_time > Time.now
    raise "Expires at #{response.headers['expires']}"
  end
end

puts '>> OK'
