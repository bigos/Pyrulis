-- fizz buzz

fizz :: Integral a => a -> Bool
fizz x = mod x 3 == 0

buzz :: Integral a => a -> Bool
buzz x = mod x 5 == 0

-- results from to step
results :: Integer -> Integer -> Integer -> [String]
results f t s = map resulter [f, (f+s) .. t]

checker :: Integral t => t -> [Bool]
checker x = map (\fn -> fn x) [fizz, buzz]

worder :: [Bool] -> [String]
worder aa = zipWith (\a b -> if a then b else "" ) aa ["Fizz", "Buzz"]

resulter :: (Show t, Integral t) => t -> String
resulter x =
  if ((worder(checker x)) == ["", ""])
  then (show x)
  else (concat (worder (checker x)))

main :: IO ()
main = mapM_ (\x -> putStrLn x) (results 1 30 1)
