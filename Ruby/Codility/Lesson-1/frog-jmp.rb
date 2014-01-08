def solution(x, y, d)
  dist = y - x
  if (dist % d) == 0
    dist / d
  else
    Integer(dist / d) + 1
  end
end

p solution(10, 85, 30)
