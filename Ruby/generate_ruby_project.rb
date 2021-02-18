#! /usr/bin/env ruby

def prompt(str)
  puts str
  $stdin.gets.strip
end

def prepare_rvm gs
  `echo #{RUBY_VERSION} > .ruby-version`
  `echo #{gs} > .ruby-gemset`
end

def prepare_gemfile
  content = <<~HERE
source 'https://rubygems.org'

gem 'rubocop', require: false
gem 'minitest', '~> 5.3.4'
  HERE

  `echo "#{content}" > Gemfile`
end

def main
  puts 'Will generate project'

  pn = prompt 'Enter new project name'
  puts "entered #{pn.inspect}"

  existing_gems = `rvm gemset list`.split('=>')[1].split
  puts 'Warning: you have such gem already' if existing_gems.include? pn

  `mkdir #{pn}`
  Dir.chdir pn

  prepare_rvm pn
  prepare_gemfile

  Dir.chdir '..'

  puts ''
  puts "Project #{pn} skeleton has been generated."
  puts 'Now you can cd to it, edit the Gemfile and run:'
  puts 'gem install bundler'
  puts 'bundle install'
  puts ''
  puts 'At this point you can create *.rb files and start tinkering.'

  # final ===================================================
  puts ''
end

main
