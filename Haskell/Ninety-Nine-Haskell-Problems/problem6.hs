palindrome :: (Eq a) => [a] -> Bool
palindrome xs = p [] xs xs
  where p rev (x:xs) (_:_:ys) = p (x:rev) xs ys
        p rev (x:xs) [_] = rev == xs
        p rev xs [] = rev == xs
