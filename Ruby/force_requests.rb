#! /usr/bin/ruby
# using ruby 1.9.3p194@global

require 'net/http'
require 'date'

# request a page
def get_web_page(address, page, user_agent = 'logrotation_tester' )
  http = Net::HTTP.new(address, 80)
  req = Net::HTTP::Get.new("page", {'User-Agent' => user_agent})
  response = http.request(req)
  return  response.body
end

# request many pages
many = 50
many.times do |x|
  get_web_page('127.0.0.1', '/index.html', "logrotation_tester-#{x}" )
end

many.times do |x|
  get_web_page('127.0.0.1', '/wrong-index.html', "logrotation_tester-#{x}" )
end

# get logrotated files
logdir = '/var/log/apache2'
dir = Dir.new logdir
files = []
dir.each do |fn|
  if fn =~ /\A.+\.log\.\d+/
    files << fn
  end
end
#p files

now = Date.today
files.each do |f|
  md = /log\.\d+/.match f
  lognum = (/\d+/.match md.to_s).to_s
  #puts "#{f}   #{lognum}"
  date = (now - lognum.to_i)
  command = "sudo touch -d #{date} #{logdir}/#{f}"
  p command
  `#{command}`
end
