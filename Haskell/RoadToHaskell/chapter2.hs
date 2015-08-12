-- Exercise 2.2 page 33/n+11
orTable :: [(Bool, Bool)] -> [(Bool, Bool, Bool)]
orTable xs = map (\x -> (fst x, snd x, fst x || snd x)) xs

-- implication
(==>) :: Bool -> Bool -> Bool
<<<<<<< HEAD
p ==> q = (not p) || q -- if you pass the test then my name is Obama
=======
x ==> y = (not x) || y
-- if you pass the test then my name is Obama
-- or my name is not Obama if you fail the test
>>>>>>> 5167d9cf7a1522a1b4cc6795a17c20cd94611163
-- direct version
-- True ==> x  = x
-- False ==> x = True

-- 5 < n ⇒ 3 < n.

-- principles

-- a false statement implies anything (T/F)
-- innocent until proven guilty

-- p | q | p implies q
-- T | T | T
-- T | F | F
-- F | T | T
-- F | F | T

-- opposite of p IMPLIES q is: p AND NOT q


-- Equivalence
