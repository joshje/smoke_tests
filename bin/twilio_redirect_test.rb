#!/usr/bin/env ruby

require 'bundler/setup'
require 'faraday'
require 'json'

domain = ARGV[0]

puts ">> Checking #{domain} at #{Time.now}"

conn = Faraday.new(domain)

response = conn.post('/twilio', 'To': ENV['TWILIO_REDIRECT_TWILIO_NUMBER'])

if response.body =~ /#{Regexp.escape(ENV['TWILIO_REDIRECT_CAB_NUMBER'])}/
  puts '> Handles Twilio webhook'
else
  raise '> Should handle Twilio webhook'
end

puts '>> OK'
