class Counters
  def initialize(n)
    @counters = Array.new(n,0)
  end
  def increase(x)
    @counters[x-1] += 1
  end
  def max_counter
    max = @counters.max
    for x in 0 .. (@counters. size) -1
      @counters[x]=max
    end
    @counters
  end
  def solution(n,a)
    m = a.size
    for k in 0 .. m-1
      if 1 <= a[k] and a[k] <= n
        increase(a[k])
      elsif a[k] == n + 1
        max_counter
      else
        raise 'error'
      end
      #p self
    end
    @counters
  end
end

def solution(n, a)
  cnt = Counters.new(n)
  cnt.solution(n,a)
end




p solution(5,[3,4,4,6,1,4,4])
