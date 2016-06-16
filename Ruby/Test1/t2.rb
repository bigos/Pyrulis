# you can write to stdout for debugging purposes, e.g.
# puts "this is a debug message"

require 'date'


def next_monday(d)
  x = 0
  x += 1 while (d + x).wday != 1
  d + x
end

def solution(y, a, b, w)
  # write your code in Ruby 2.2
  first_day = Date.parse "#{y}-#{a}-1"
  first_monday = next_monday(first_day)
  last_day_month = Date.parse("#{y}-#{b}-1").month

  w = 1
  puts 'fm'
  p first_monday
  p first_monday.month
  p last_day_month
  while (first_monday + w * 7).month < last_day_month + 1
    w += 1
  end
  w - 1
end

p solution(2014, 'April', 'May', 'Wednesday')
puts '====================='
p solution(2016, 'april', 'june', 'Wednesday')
