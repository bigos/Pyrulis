class Counters
  def initialize(n)
    @counters = Array.new(n,0)
    @max = 0
  end
  def increase(x)
    @counters[x-1] += 1
  end
  def solution(n,a)
    m = a.size
    for k in 0 .. m-1
      if 1 <= a[k] and a[k] <= n
        premax = increase(a[k])
        @max = premax if premax > @max
      elsif a[k] == n + 1
        # max_counter
        for x in 0 .. (@counters.size) -1
          @counters[x]=@max
        end
        @counters
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

require 'benchmark'

puts Benchmark.measure {
  p solution(5,[3,4,4,6,1,4,4])
}

puts Benchmark.measure {
  p solution(500,[1,2,3,4,5,6,2,2,2]+([1,501]*555))
}
