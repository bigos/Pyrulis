def solution(s, p, q)
  zz=[]
  for x in 0 .. p.size-1
    zz << (s.slice p[x] .. q[x])
  end
  codes = {'A'=>1,'C'=>2,'G'=>3,'T'=>4}
  result = []
  zz.each { |z|
    f = 5
    z.each_char { |c|
      f = codes[c] if codes[c] < f }
    result << f }
  result
end

p solution("GACACCATA", [0,0,4,7,], [8,2,5,7])
#           012345678
