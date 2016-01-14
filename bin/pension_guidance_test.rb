#!/usr/bin/env ruby

require 'bundler/setup'
require 'date'
require 'faraday'

domain = ARGV[0]
staging = domain =~ /staging/
production = !staging
pages = %w(
  /
  /6-steps-you-need-to-take
  /adjustable-income
  /already-bought-annuity
  /appointments
  /benefits
  /care-costs
  /combine-pots
  /contact
  /cookies
  /cymraeg
  /divorce
  /financial-advice
  /guaranteed-income
  /leave-pot-untouched
  /living-abroad
  /locations
  /locations/15fd41b2-439a-448a-b775-b2b61e16d4bb
  /making-money-last
  /mix-options
  /pension-complaints
  /pension-pot-options
  /pension-pot-value
  /pension-types
  /privacy
  /protection
  /scams
  /shop-around
  /take-cash-in-chunks
  /take-whole-pot
  /tax
  /when-you-die
  /work-out-income
)

puts ">> Checking #{domain} at #{Time.now}"

conn = Faraday.new(domain)

if staging && ENV['AUTH_USERNAME'] && ENV['AUTH_PASSWORD']
  conn.basic_auth( ENV['AUTH_USERNAME'], ENV['AUTH_PASSWORD'])
end

for page in pages do
  puts page
  response = conn.get(page)

  unless response.status == 200
    raise "Status code was #{response.status}"
  end

  if production
    unless DateTime.parse(response.headers['expires']).to_time > Time.now
      raise "Expires at #{response.headers['expires']}"
    end
  end
end

puts '>> OK'
