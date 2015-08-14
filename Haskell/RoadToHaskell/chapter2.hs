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
verdict p q = (result, remark)
  where result = p ==> q
        remark | not result = "LIAR"
               | p = "telling the truth"
               | otherwise = "innocent unless proven guilty"
-- map (\x -> (verdict (fst x==1) (snd x ==1)) ) [(1,1),(1,0),(0,1),(0,0)

-- Equivalence page 35/46

-- an equivalence P ⇔ Q amounts to the conjunction of two implications
-- P ⇒ Q and Q ⇒ P taken together

iff :: Bool -> Bool -> Bool
iff p q = result
  where result = p ==> q && q ==> p
-- map (\x -> (myEquivalence (fst x==1) (snd x ==1)) ) [(1,1),(1,0),(0,1),(0,0)

-- Example 2.3 page 36/n+11

-- Example 2.4

-- the formula
-- ¬P ∧ ((P ⇒ Q) ⇔ ¬(Q ∧ ¬P )).

p = True
q = False
formula1 = (not p) && (p ==> q) `iff` not (q && (not p))

-- 2.2 Logical Validity and Related Notions -- page 38/49
