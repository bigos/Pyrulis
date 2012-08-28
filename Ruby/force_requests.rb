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

def touch_log_files()
  # get logrotated files
  logdir = '/var/log/apache2'
  dir = Dir.new logdir
  files = []
  dir.each do |fn|
    files << fn if fn =~ /\A.+\.log\.\d+/
  end

  now = Date.today
  files.each do |f|
    md = /log\.\d+/.match f
    lognum = (/\d+/.match md.to_s).to_s
    #puts "#{f}   #{lognum}"
    date = (now - lognum.to_i)
    command = "sudo touch -d #{date} #{logdir}/#{f}"
    #p command
    `#{command}`
  end
end

def day_log()
  many = 20
  many.times do |y|
    #get_web_page('127.0.0.1', '/index.html', "logrotation_tester-#{y}" )
    #get_web_page('127.0.0.1', '/wrong-index.html', "logrotation_tester-#{y}" )
    #`sudo cp /var/log/apache2/sample_file.txt   /var/log/apache2/my_access.log`
  end
  touch_log_files()
end

10.times do
  7.times do
    day_log()
    `sudo cp /var/log/apache2/sample_file.txt   /var/log/apache2/my_access.log`
    `sudo logrotate -v -f ./logrotate_apache2.txt `
  end
  `sudo logrotate -v -f ./logrotate_apache3.txt `
end
