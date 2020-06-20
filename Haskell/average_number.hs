-- average number

module Main where

import Data.List
import Data.Function

flodiv a b = (fromIntegral a) / (fromIntegral b)

strToInts s = map (\n -> read n :: Integer)  (words s)

sol nn =
  show (if final == []
        then ( (-1))
        else ( floor (head final)))
  where
    n  = head nn !! 0
    k  = head nn !! 1
    v  = head nn !! 2
    ax = nn !! 1
    spil = n + k
    sumr = sum ax
    sumn x = (sumr + (k * x))
    avl = (n + k)
    formula x = flodiv (sumn x) avl
    formulas = (map formula [0 .. spil])
    final = (filter (\a-> a  == (fromInteger v)) formulas)

solution :: String -> [String]
solution a =
  tcx
  where
    ll = lines a
    t = head (strToInts (head ll))
    si n e = strToInts (ll !! (e*2+n))
    endv = (fromIntegral (t - 1))
    tcx = map (\e -> sol [si 1 e , si 2 e]) [0 ..  endv]

main = getContents >>= mapM putStrLn . solution
