def solution(a)
  n = a.size
  r = a.reverse

  #p a
  sa=Array.new n-1
  sr = Array.new n-1
  for x in 1..(n-1)
    sa[x-1] = a[0,x].inject(:+)
    sr[x-1] = r[0,x].inject(:+)
  end
  sr.reverse!

  r=2000
  for x in 0 .. sa.size-1
    r2 = (sa [x]-sr [x]).abs
    if r2 < r
      r = r2
    end

  end
  r
end

p solution [3, 1, 2, 4, 3]
