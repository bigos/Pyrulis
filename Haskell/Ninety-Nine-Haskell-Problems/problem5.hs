 -- 5 Problem 5
-- (*) Reverse a list.

reverse :: [a] -> [a]
reverse [] = []
reverse (x:xs) = reverse xs ++ [x]
