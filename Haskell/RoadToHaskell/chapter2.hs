-- Exercise 2.2 page 33/n+11
orTable :: [(Bool, Bool)] -> [(Bool, Bool, Bool)]
orTable xs = map (\x -> (fst x, snd x, fst x || snd x)) xs

-- implication
(==>) :: Bool -> Bool -> Bool
x ==> y = (not x) || y
-- if you pass the test then my name is Obama
-- or my name is not Obama if you fail the test
-- direct version
-- True ==> x  = x
-- False ==> x = True

-- 5 < n ⇒ 3 < n.


-- Equivalence
