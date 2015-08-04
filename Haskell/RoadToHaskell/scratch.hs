remit i a n | head(snd(s)) == n = (fst s) + (tail(snd(s)))
            | otherwise = remit i a (n + 1)
  where s =  splitAt n a

removeFst :: Int -> [Int] -> [Int]
removeFst i [] = []
removeFst i a = remit i a 0
