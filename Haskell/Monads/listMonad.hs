-- list monad

-- example defined elsewhere
-- instance Monad [] where
--   -- return :: a -> [a]
--   return x = [x] --make a list containing the one element given

--   -- (>>=) :: [a] -> (a -> [b]) -> [b]
--   xs >>= f = concat (map f xs)
--              -- collect all the results of f which re lists
--              -- and combine them into a new list

oneTwoThree :: [Integer]
oneTwoThree = [1,2,3]

main :: IO ()
main = do
  putStrLn "List monad will go here."
  putStrLn "it selves"
  print (show $ oneTwoThree >>= (\x -> [x]))
  putStrLn "itself and double and zero"
  print (show $ oneTwoThree >>= (\x -> [x, 2*x, 0]))
