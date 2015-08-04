removeFst :: Int -> [Int] -> [Int]
removeFst _ [] = []
removeFst i (x:xs) | i == x = xs
                   | otherwise = x : removeFst i xs
