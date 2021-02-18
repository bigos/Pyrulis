#! /usr/bin/env ruby

def prompt(str)
  puts str
  $stdin.gets.strip
end

def main
  puts 'Will generate project'

  pn = prompt 'Enter new project name'
  puts "entered #{pn.inspect}"

  existing_gems = `rvm gemset list`.split('=>')[1].split
  puts 'Warning: you have such gem already' if existing_gems.include? pn

  `mkdir #{pn}`
  Dir.chdir pn

  `echo #{RUBY_VERSION} > .ruby-version`
  `echo #{pn} > .ruby-gemset`




  Dir.chdir '..'
  #final ===================================================
  puts ''
end

main
