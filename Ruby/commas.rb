def commas(num)
  str=num.to_s.reverse
  res = ''
  for x in 0 .. (str.size-1)
    res << str[x]
    if (((x+1) % 3) == 0) and x < (str.size-1)
      res << ','
    end
  end
  res.reverse
end

p commas(1000000)
p commas(999999)
