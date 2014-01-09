def solution(a)
  n = a.size
  min = 2000
  b = a.reverse
  #p a
  for x in 1 .. n-1
    a[x] = a[x-1] + a[x]
    b[x] = b[x-1] + b[x]
  end
  #puts "#{x} : #{a.inspect}  #{b.inspect}"
  b.reverse!
  #p a
  #p b
  for x in 0 .. a.size-2
    s=a[x]
    e=b[x+1]
    r2 = (s - e).abs
    #puts "#{s} #{e}  #{r2}"
    if r2 < min
      min = r2
    end
  end
  min
end

p solution [3, 1, 2, 4, 3]
p solution [-1000, 1000]
