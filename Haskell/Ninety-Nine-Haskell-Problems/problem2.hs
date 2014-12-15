myButLast [] = error "empty list"
myButLast [y] = error "only one element"
myButLast x = x !! (length x - 2)
