#! /usr/bin/env ruby

puts 'testing implications'
# run like this from Emacs eshell
# ~/.rvm/rubies/ruby-2.2.1/bin/ruby ./implication.rb

def a(n)
  5 < n
end

def b(n)
  3 < n
end

[2,3,4,5,6].each do |n|
  ares = a n
  bres = b n
  print n, ' ',bres, ' ', ares, ' - ', (!bres || ares)
  puts
end

puts '---------------'

v = [[true, true], [true, false], [false, true], [false, false]]
v.each do |n|
  p (!n [0] || n [1])
end
