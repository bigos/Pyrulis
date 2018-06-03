#! /usr/bin/env ruby

EMACSD = '.emacs.d'

puts ''

def emacs_folder_entries
  # emacs configuration folders should start with '.emacs.d-'
  pattern = "#{EMACSD}-"
  Dir.entries(Dir.home).collect { |x| x if x.index(pattern) }.reject(&:nil?)
end

def input(prompt)
  print prompt
  print '> '
  gets
end

def print_folder_options(config_folders)
  puts 'Select emacs config number'
  config_folders.each_index do |ci|
    puts "#{ci} #{config_folders[ci]}"
  end
end

def apply_option(config_folders)
  default_config_folder = File.join(Dir.home, EMACSD)
  begin
    opt = Integer(input('Option'))
    raise ArgumentError unless config_folders[opt]

    File.delete(default_config_folder) if File.exist?(default_config_folder)
    File.symlink(File.join(Dir.home, config_folders[opt]),
                 default_config_folder)
  rescue ArgumentError
    puts 'Invalid option entered'
  end
end

def check_if_proceed(config_folders)
  default_config_folder = File.join(Dir.home, EMACSD)
  if File.exist? default_config_folder
    if File.symlink?(default_config_folder)
      puts 'this action will overwrite the existing symlink'
      puts 'pointing to ' + File.readlink(default_config_folder)
      puts ''
    else
      puts "#{EMACSD} is not a symlink"
      puts 'to use this utility, in your terminal do something like this:'
      puts "$ mv #{default_config_folder} #{default_config_folder}-alternative-config"

      puts ' exiting...'
      return false
    end
  else
    puts "no #{EMACSD} found in your home folder"
    if config_folders.empty?
      puts 'nor folders with alternative emacs config'
      puts ' exiting...'
      return false
    else
      puts 'will try to symlink one of the found folders'
    end
  end
  if config_folders.empty?
    puts 'No alternative config folders found, exiting...'
    return false
  end
  true
end

def main
  config_folders = emacs_folder_entries
  proceed = check_if_proceed(config_folders)
  return false unless proceed

  print_folder_options(config_folders)
  apply_option(config_folders)
end
# ------ start the script here -----
main
