removeFst :: Int -> [Int] -> [Int]
removeFst _ [] = []
removeFst i (x:xs) | i == x = xs
                   | otherwise = x : removeFst i xs

                                 -- loading several modules
                                 -- :add ./mod1.hs
                                 -- :add ./mod2.hs
