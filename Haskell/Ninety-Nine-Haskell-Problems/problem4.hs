 -- 4 Problem 4
-- (*) Find the number of elements of a list.
-- Example in Haskell:
-- Prelude> myLength [123, 456, 789]
-- 3
myLength           :: [a] -> Int
myLength []        =  0
myLength (_:xs)    =  1 + myLength xs
