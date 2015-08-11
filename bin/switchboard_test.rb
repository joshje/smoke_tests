#!/usr/bin/env ruby

require 'bundler/setup'
require 'faraday'
require 'json'

domain = ARGV[0]

puts ">> Checking #{domain} at #{Time.now}"

conn = Faraday.new(domain)

response = conn.get("/lookup/#{ENV['SWITCHBOARD_LOCATION_ID']}")
json = JSON.parse(response.body)

if json['phone'] == ENV['SWITCHBOARD_TWILIO_NUMBER']
  puts '> Performs Twilio number lookup'
else
  raise '> Should perform Twilio number lookup'
end

response = conn.post('/twilio', 'To': ENV['SWITCHBOARD_TWILIO_NUMBER'])

if response.body =~ /#{Regexp.escape(ENV['SWITCHBOARD_CAB_NUMBER'])}/
  puts '> Handles Twilio webhook'
else
  raise '> Should handle Twilio webhook'
end

puts '>> OK'
