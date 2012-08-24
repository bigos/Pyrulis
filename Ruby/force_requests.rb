#! /usr/bin/ruby
# using ruby 1.9.3p194@global

http = Net::HTTP.new("localhost", 80)
req = Net::HTTP::Get.new("/index.html", {'User-Agent' => 'logrotation_tester'})
response = http.request(req)
puts response.body
