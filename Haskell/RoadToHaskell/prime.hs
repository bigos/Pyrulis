divides :: Integer -> Integer -> Bool
divides d n = rem n d == 0

ld :: Integer -> Integer
ld n = ldf 2 n

ldf :: Integer -> Integer -> Integer
ldf k n | divides k n = k
        | k^2 > n = n
        | otherwise = ldf (k+1) n

prime0 :: Integer -> Bool
prime0 n | n < 1 = error "not a positive integer"
         | n == 1 = False
         | otherwise = ld n == n


{- page 14/25 - exercise 1.10 -}

-- loading several modules
-- :add ./mod1.hs
-- :add ./mod2.hs

removeFst :: Int -> [Int] -> [Int]
removeFst _ [] = []
removeFst i (x:xs) | i == x = xs
                   | otherwise = x : removeFst i xs

-- Example 1.11
-- where version
srtInts :: [Int] -> [Int]
srtInts [] = []
srtInts xs = m : (srtInts(removeFst m xs)) where m = minimum xs
-- usage:
-- srtInts( removeFst 2 [1,2,3,4,5,4,3,2,1] )

-- let version
srtInts' :: [Int] -> [Int]
srtInts' [] = []
srtInts' xs = let
  m = minimum xs
  in m : (srtInts'(removeFst m xs))


-- Example 1.12 page 26/15

-- Example 1.13
count :: Char -> String -> Int
count c cs = sum( map (\x -> if c == x then 1 else 0) cs)

-- Excercise 1.14
blowup :: String -> String
blowup "" = ""
blowup s =  blowup (init s) ++ (replicate (length s) (last s))
