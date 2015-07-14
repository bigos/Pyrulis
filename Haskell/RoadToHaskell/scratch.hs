removeFst :: Int -> [Int] -> [Int]
removeFst i lints | lints == [] = lints
                  | otherwise = removeFst i lints
