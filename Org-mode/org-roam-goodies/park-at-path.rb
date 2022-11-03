#!/usr/bin/env ruby

target_folder = '/home/jacekp/Documents/Roams/EDIT_ME'

org_roam = 'org-roam'
raise "target folder #{target_folder} does not exist" unless Dir.exist? target_folder
current_folder = Dir.pwd
puts "going to park from #{current_folder} to #{target_folder}"


we_have_target = Dir.new(target_folder).entries.member? org_roam
if we_have_target
  from_dir = File.join(target_folder, org_roam)
  to_dir   = from_dir + '-backup-' + Time.now.to_i.to_s

  backup_command = "mv -v #{from_dir} #{to_dir}"
  puts 'backing up'
  puts backup_command
  `#{backup_command}`
end

command = "mv -v #{current_folder} #{target_folder}"
puts "going to execute: #{command}"
`#{command}`
