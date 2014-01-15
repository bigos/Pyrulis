def solution(s, p, q)
  n = s.size
  codes={'A'=>1,'C'=>2,'G'=>3,'T'=>4}
  result=[]
  for x in 0 .. p.size-1
    #range =[p[x],q[x]]
    #p range
    z = s.slice p[x] .. q[x]
    f = 5
    z.each_char { |c|
      f=codes[c] if codes[c] < f
    }
    result << f
  end
  result
end

p solution("GACACCATA", [0,0,4,7,], [8,2,5,7])
#           012345678
