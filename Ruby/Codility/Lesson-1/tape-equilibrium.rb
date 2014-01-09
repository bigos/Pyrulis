def solution(a)
  n = a.size
  r = a.reverse
  p a
  for x in 1 .. n-1
    a[x] = a[x-1] + a[x]
    r[x] = r[x-1] + r[x]

  end
    puts "#{x} : #{a.inspect}  #{r.inspect}"
  r.reverse!
  #p a
  #p r
  r1 = 200
  for x in 0 .. a.size-2
    s=a[x]
    e=r[x+1]
    r2 = (s - e).abs
    #puts "#{s} #{e}  #{r2}"
    if r2 < r1
      r1 = r2
    end
  end
  r1
end

p solution [3, 1, 2, 4, 3]
p solution [-1000, 1000]
