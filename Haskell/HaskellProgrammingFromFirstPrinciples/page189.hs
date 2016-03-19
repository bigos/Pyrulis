module Arith3Broken where

main :: IO ()
main = do
  print (1 + 2 :: Int)
  print (10 :: Int)
  print (negate (-1) :: Int)
  print ((+) 0 blah :: Int)
  where blah = negate 1
