#!/usr/bin/env ruby

require 'bundler/setup'
require 'date'
require 'faraday'

domain = 'https://staging-www.pensionwise.gov.uk/'
pages = %w(
  /
  /6-steps-you-need-to-take
  /already-bought-annuity
  /appointments
  /benefits
  /complaints
  /cookies
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

if ENV['AUTH_USERNAME'] && ENV['AUTH_PASSWORD']
  conn.basic_auth( ENV['AUTH_USERNAME'], ENV['AUTH_PASSWORD'])
end

for page in pages do
  puts page
  response = conn.get(page)

  unless response.status == 200
    raise "Status code was #{response.status}"
  end
end

puts '>> OK'
