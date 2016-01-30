module Reverse where

thirdLetter :: String -> Char
thirdLetter x = x !! 3

letterIndex :: Int -> Char
letterIndex x = "Curry is awesome" !! x

rvrs :: String -> String
rvrs x = (drop 9 x) ++ " " ++ (drop 6 (take 8 x)) ++ " " ++ (take 5 x)

main :: IO ()
main = print $ rvrs "Curry is awesome"
