def solution(a)
  n = a.size
  p a
  if n > 1000000000
    -1
  else
    n
  end
end

# is the task description incorrect?
p solution %w(0 1 0 1 1) # => 5
p solution %w(1) # => 0
p solution %w(1 0) # => 0
