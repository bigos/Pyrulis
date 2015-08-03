removeFst' i n a | head (snd spl) == i = (fst spl) ++ tail (snd spl)
                 | otherwise =  removeFst' i (n + 1) a
  where spl = splitAt n a

removeFst i a = removeFst' i 0 a
