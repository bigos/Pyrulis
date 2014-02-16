def solution(a)
  n = a.size
  res = -1000 ^ 3
  for p in 0 .. (n-3)
    for q in (p+1) .. (n-2)
      for r in (q+1) .. (n-1)
        if ((0 <= p) and (p < q) and (q < r) and (r < n))
          v = (a[p] * a[q] * a[r])
          res = v if v > res
          #puts "p#{p}* q#{q}* r#{r}= #{a[p] * a[q] * a[r]} "
        end
      end
    end
  end
  res
end

p solution [-3,1,2,-2,5,6]
