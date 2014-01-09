def solution(a)
  a.sort!
  n = a.size
  #p a
  if n == 0
    return 1
  elsif n == 1
    if a[0] == 1
      return a[0]+1
    else
      return 1
    end
  else
    for x in 0..(n-1)
      unless a[x] == x+1
        return x+1
      end
    end
  end
  n+1
end


p solution [2, 3, 1, 5]
p solution [3, 1]
p solution [2, 1]
p solution [1]
p solution [2] #must return 1
p solution []
