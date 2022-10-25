#!/usr/bin/env ruby

#require 'byebug'

raise "you are not in home directory" unless Dir.pwd.start_with?(Dir.home)
raise "you are not in Roam directory" unless Dir.pwd.end_with?('Roams')

target_folder = File.join Dir.home ,'Documents', 'org-roam'
raise "target folder exists #{target_folder}" if Dir.exist? target_folder

#puts ARGV.inspect

raise "no starting folder supplied" if ARGV.size.zero?
raise "too many arguments" if ARGV.size > 1

source_folder = ARGV.first

# byebug
# 1==1

copied_folder = File.join source_folder, 'org-roam'
raise "source folder does not exist #{copied_folder}" unless Dir.exist? copied_folder

command = "cp -Rv #{copied_folder} #{target_folder}"
puts "going to execute: #{command}"
`#{command}`
