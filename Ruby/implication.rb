#! /usr/bin/env ruby

puts 'testing implications'

def a(n)
  5 < n
end

def b(n)
  3 < n
end

[2,4,6].each do |n|
  ares = a n
  bres = b n
  print n, ' ',ares, ' ', bres, ' - ', (!ares || bres)
  puts
end

puts '---------------'

v = [[true, true], [true, false], [false, true], [false, false]]
v.each do |n|
  p (!n [0] || n [1])
end
