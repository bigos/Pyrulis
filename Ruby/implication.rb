#! /usr/bin/env ruby

puts 'testing implications'

def a(n)
  5 < n
end

def b(n)
  3 < n
end

[1,2,3,4,5,6,7].each do |n|
  ares = a n
  bres = b n
  print n, ' ',ares, ' ', bres, ' - ', (!ares || bres)
  puts
end
