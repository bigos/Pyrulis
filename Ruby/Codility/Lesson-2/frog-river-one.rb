def fn(x)
  (2 ** (x+1))
end

# def solution(x, a)
#   n = a.size
#   #p a
#   zzz=0
#   expected = (2 ** (x+1))-2
#   #puts "expected #{expected}"
#   for x in 0 .. n-1
#     zzz = (zzz | 2**a[x])
#     #puts " #{2**a[x]} #{zzz}"
#     return x if zzz == expected
#   end
#   -1
# end

def solution(x, a)
  n = a.size
  pos = 0
  k = 0
  count = 0
  r = Array.new x
  puts "*********  #{x}   #{a.inspect}"
  for z in 0 .. n-1
    unless r[a[z]-1]
      r[ a[z]-1 ] = a[z]
      count += 1
    end
    puts ":: #{z} #{count}  #{r.inspect}"
    if count == x
      return z
    end
    # if r.all? { |e| e != nil }
    #   puts "final count "+count.to_s
    #   return z
    # end
  end
  -1
end

p solution(3, [3, 2, 1]) # expect 2

p solution(5, [1, 3, 1, 4, 2, 3, 5, 4]) # expect 6

p solution(1, [1]) # expect 0

p solution(50, [4, 16, 1, 40, 2, 34, 44, 7, 15, 36, 1, 31, 21, 5, 46, 40, 11, 43, 12, 3, 15, 17, 27, 18, 32, 46, 50, 43, 35, 49, 13, 31, 8, 5, 41, 42, 22, 10, 19, 39, 35, 18, 45, 38, 30, 35, 48, 24, 17, 24, 8, 2, 20, 20, 49, 45, 47, 29, 41, 16, 19, 32, 5, 13, 33, 28, 4, 40, 18, 7, 15, 39, 28, 23, 6, 9, 25, 37, 8, 6, 21, 50, 26, 14, 27, 9, 47, 44, 21, 48, 48, 3, 28, 7, 29, 23, 27, 11, 46, 43, 50, 26, 10, 41, 36, 33, 42, 14, 49, 12, 13, 32, 42, 36, 17, 45, 30, 1, 47, 19, 24, 16, 26, 39, 37, 31, 25, 20, 4, 10, 23, 34, 9, 12, 2, 6, 34, 38, 22, 22, 14, 44, 11, 37, 3, 29, 33, 25, 38, 30])
#expect 83