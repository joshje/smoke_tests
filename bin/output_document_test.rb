#!/usr/bin/env ruby

require 'bundler/setup'
require 'date'
require 'mechanize'

domain = ARGV[0]
email = ENV['OUTPUT_DOCUMENT_EMAIL']
password = ENV['OUTPUT_DOCUMENT_PASSWORD']

puts ">> Checking #{domain} at #{Time.now}"

mech = Mechanize.new

page = mech.get(domain)

if page.body =~ /Log in/
  puts '> Renders login form'
else
  raise 'Should render login form'
end

form = page.forms.first
form['user[email]'] = email
form['user[password]'] = password

page = form.submit(form.buttons.first)

if page.body =~ /issue a summary document/
  puts '> Renders logged in view'
else
  raise 'Should be logged in'
end

puts '>> OK'
