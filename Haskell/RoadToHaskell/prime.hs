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


-- Exercise 1.15
strString :: [String] -> [String]
strString [] = []
strString (x:xs) = strString small ++ (x : strString large)
  where
    small = [y | y <- xs, y <= x]
    large = [y | y <- xs, y > x]

-- Example 1.16
prefix :: String -> String -> Bool
prefix [] ys = True
prefix (x:xs) [] = False
prefix (x:xs) (y:ys) = (x==y) && prefix xs ys

-- Exercise 1.17 page 28/17
substring :: String -> String -> Bool
substring x [] = False
substring x (y:ys) = if prefix x (y:ys) then True else substring x ys

-- Section 1.6 Haskell Types
-- Section 1.7 Prime Factorisation

factors :: Integer -> [Integer]
factors n | n < 1  = error "Argument not positive"
          | n == 1 = []
          | otherwise = p : factors (div n p)
  where p = ld n

-- Section 1.8 The map and filter Functions

-- Exercise 1.20 page 22/33
lengths :: [[a]] -> [Int]
lengths [] = []
lengths xs = map length xs

-- Exercise 1.21
sumLengths :: [[a]] -> Int
sumLengths xs = sum $ map length xs

-- Example 1.22
primes1 :: [Integer]
primes1 = filter prime0 [2..]

-- Example 1.23
ldp :: Integer -> Integer
ldp  = ldpf primes1

ldpf :: [Integer] -> Integer -> Integer
ldpf (p:ps) n | rem n p == 0 = p
              | p^2 > n      = n
              | otherwise    = ldpf ps n

-- Exercise 1.24
-- it will still work because of ldp also being a prime
