removeFst' :: Int -> [Int] -> [Int] -> [Int]
removeFst' i [] result = []
removeFst' i (x:xs) result | i == x = result
removeFst' i lints result = removeFst' i z

removeFst :: Int -> [Int] -> [Int]
removeFst i lints | lints == [] = lints
                  | otherwise = removeFst' i lints []
