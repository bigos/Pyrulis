def solution(n)
  str=n.to_s.reverse!
  ns=''
  counter = 1
  for x in 0 .. str.size-1
    ns << str[x,1]
    if counter % 3 == 0
      ns << ','
    end
    counter +=1
  end
  # that's why I failed the test
  ns.reverse! # <--- this did the trick
  if ns[0,1] == ','
    ns[1..-1]
  else
    ns
  end
end

p solution 123456789
