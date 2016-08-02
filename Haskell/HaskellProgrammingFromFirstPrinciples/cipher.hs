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
myOr = undefined

myAny :: (a -> Bool) -> [a] -> Bool
myAny = undefined

myElem :: Eq a => a -> [a] -> Bool
myElem = undefined

myReverse :: [a] -> [a]
myReverse = undefined

squish :: [[a]] -> [a]
squish = undefined

squishMap :: (a -> [b]) -> [a] [b]
squishMap = undefined

squishAgain :: [[a]] -> [a]
squishAgain = undefined

myMaximumBy :: (a -> a -> Ordering) -> [a] -> a
myMaximumBy = undefined

myMinimumBy :: (a -> a -> Ordering) -> [a] -> a
myMinimumBy = undefined

myMaximum :: (Ord a) => [a] -> a
myMaximum = undefined

myMinimum :: (Ord a) => [a] -> a
myMinimum = undefined
