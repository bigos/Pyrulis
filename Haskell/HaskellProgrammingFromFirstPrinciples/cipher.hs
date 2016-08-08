module Cipher where

import Data.Char

unCaesar :: String -> String
unCaesar s = undefined

-- with direct recursion not using &&
myAnd :: [Bool] -> Bool
myAnd [] = True
myAnd (x:xs) = if x == False then False else myAnd xs


-- with direct recursion using &&
-- myAnd :: [Bool] -> Bool
-- myAnd [] = True
-- myAnd (x:xs) = x && myAnd xs

myOr :: [Bool] -> Bool
myOr [] = False
myOr (x:xs) = if x == True then True else myOr xs

myAny :: (a -> Bool) -> [a] -> Bool
myAny fn [] = False
myAny fn (x:xs) = if (fn x) == True then True else myAny fn xs

myElem :: Eq a => a -> [a] -> Bool
myElem e a = myAny (\x -> e == x) a

myReverse :: [a] -> [a]
myReverse [] = []
myReverse (x:xs) = myReverse xs ++ [x]

squish :: [[a]] -> [a]
squish = concat

squishMap :: (a -> [b]) -> [a] -> [b]
squishMap fn a = squish (map fn a)

squishAgain :: [[a]] -> [a]
squishAgain = squishMap id

-- λ> scanr (\x a -> max x a) 1 [1,2,3,2]
-- myMaximumBy :: (a -> a -> Ordering) -> [a] -> a
-- myMaximumBy = undefined

-- myMinimumBy :: (a -> a -> Ordering) -> [a] -> a
-- myMinimumBy = undefined

myMaximum :: (Ord a) => [a] -> a
myMaximum = maximum

myMinimum :: (Ord a) => [a] -> a
myMinimum = minimum
