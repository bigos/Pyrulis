-- Exercise 2.2 page 33/n+11
orTable :: [(Bool, Bool)] -> [(Bool, Bool, Bool)]
orTable xs = map (\x -> (fst x, snd x, fst x || snd x)) xs

-- implication
(==>) :: Bool -> Bool -> Bool
p ==> q = (not p) || q

-- direct version
-- True  ==> q = q
-- False ==> q = True # innocent unless proven guilty

-- Principle
-- innocent unless proven guilty

-- Statement
-- if I win the elections the taxes will go down

-- p | q | p implies q
-- T | T | T   < kept the promise, so innocent
-- T | F | F   <-- LIED!!!
-- F | T | T   < not won, so innocent
-- F | F | T   < not won, so innocent

-- opposite of p IMPLIES q is: p AND NOT q
-- if I win the elections the taxes will not go down

verdict :: Bool -> Bool -> (Bool, String)
verdict p q = verdict2 p (p ==> q)
-- map (\x -> verdict (fst x == 1) (snd x == 1)) [(1,1),(1,0),(0,1),(0,0)]

verdict2 :: Bool -> Bool -> (Bool, String)
verdict2 True True  = (True, "telling the truth")
verdict2 True False = (False, "LIAR")
verdict2 False _    = (True, "innocent unless proven guilty")
-- will get warning - verdict2 _ True     = (True, "innocent unless proven guilty")
-- map (\x -> verdict2 (fst x) ((fst x) ==> (snd x))) [(True,True),(True,False),(False,True),(False,False)]


-- Equivalence page 35/46
