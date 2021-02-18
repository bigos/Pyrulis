#! /usr/bin/env ruby
# frozen_string_literal: true

def prompt(str)
  puts str
  $stdin.gets.strip
end

def prepare_rvm(gem_set)
  `echo #{RUBY_VERSION} > .ruby-version`
  `echo #{gem_set} > .ruby-gemset`
end

def prepare_gemfile
  content = <<~HERE
    source 'https://rubygems.org'

    gem 'rubocop', require: false
    gem 'minitest', '~> 5.3.4'
  HERE

  `echo "#{content}" > Gemfile`
end

def prepare_source(project_name)
  content = <<~HERE
    #! /usr/bin/env ruby
    # frozen_string_literal: true

    # example source, please replace with your own
    puts 'Hi, you are running ruby:'
    puts "'#{ENV['GEM_HOME'].inspect}'"
  HERE

  `echo "#{content}" > #{project_name}.rb`
end

def gather_data
  puts 'Will generate project'

  project_name = prompt 'Enter new project name'

  existing_gems = `rvm gemset list`.split('=>')[1].split
  puts 'Warning: you have such gem already' if existing_gems.include? project_name

  project_name
end

def final_info(project_name)
  puts ''
  puts "Project #{project_name} skeleton has been generated."
  puts 'Now you can cd to it, edit the Gemfile and run:'
  puts 'gem install bundler'
  puts 'bundle install'
  puts ''
  puts "At this point you can edit the #{project_name}.rb and start tinkering."
  puts ''
end

def main
  project_name = gather_data

  `mkdir #{project_name}`

  Dir.chdir project_name

  prepare_rvm project_name
  prepare_gemfile
  prepare_source project_name

  Dir.chdir '..'

  final_info project_name
end

main
