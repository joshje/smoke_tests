#!/usr/bin/env ruby

require 'bundler/setup'
require 'date'
require 'mechanize'

domain = ARGV[0]

puts ">> Checking #{domain} at #{Time.now}"

mech = Mechanize.new

if ENV['AUTH_USERNAME'] && ENV['AUTH_PASSWORD']
  mech.add_auth(domain, ENV['AUTH_USERNAME'], ENV['AUTH_PASSWORD'])
end

page = mech.get("#{domain}/locations")

if page.body =~ /Find a face-to-face appointment location/
  puts '> Renders location finder'
else
  raise 'Should render location finder'
end

form = page.forms.first
form['postcode'] = 'LONDON'
page = form.submit(form.buttons.first)

if page.body =~ /is not a valid postcode/
  puts '> Renders invalid postcode message'
else
  raise 'Should render invalid postcode message'
end

form = page.forms.first
form['postcode'] = 'SW1A 2HQ'
page = form.submit(form.buttons.first)

if page.body =~ /Face-to-face locations near/
  puts '> Renders locations'
else
  raise 'Should render locations'
end

page = page.link_with(dom_class: 't-name').click

if page.body =~ /Camden Citizens Advice/
  puts '> Renders location'
else
  raise 'Should render location'
end

puts '>> OK'
