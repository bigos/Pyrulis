 -- 5 Problem 5
-- (*) Reverse a list.
myReverse :: [a] -> [a]
myReverse [] = []
myReverse (x:xs) = reverse xs ++ [x]
