def solution(a)
  n = a.size
  #p a
  a.sort!
  res = 1
  if a[0]==1
    for x in 1 .. n-1
      res = 0 unless a[x-1]+1 == a[x]
    end
  else
    res = 0
  end
  res
end

puts solution [4, 1, 3, 2]
puts solution [4, 1,  2]
puts solution ([1]*10000)
