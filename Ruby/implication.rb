#! /usr/bin/env ruby

puts 'testing implication if a is true then b must be true'
# run like this from Emacs eshell
# ~/.rvm/rubies/ruby-2.2.1/bin/ruby ./implication.rb

def a(n) 5 < n end

def b(n) 3 < n end

[2,4,6].each do |n|
  ares = a n
  bres = b n
  result = (!bres || ares)
  comment = "\t "
  if result
    if ares
      comment << 'true - the statement is telling the truth'
    else
      comment << 'true - innocent unless proven guilty'
    end
  else
    comment << 'false - LIAR!!!'
  end

  print n, ' ',bres, ' ', ares, ' - ', result, comment

  puts
end

puts '---------------'

v = [[true, true], [true, false], [false, true], [false, false]]
v.each do |n|
  a, b = n
  p !a || b
end
