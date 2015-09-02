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

(<=>) :: Bool -> Bool -> Bool
(<=>) p q = result
  where result = p ==> q && q ==> p
-- map (\x -> ( (fst x==1) <=> (snd x ==1)) ) [(1,1),(1,0),(0,1),(0,0)

-- Example 2.3 page 36/n+11

-- Example 2.4
(<+>) :: Bool -> Bool -> Bool
x <+> y = x /= y

-- the formula
-- ¬P ∧ ((P ⇒ Q) ⇔ ¬(Q ∧ ¬P )).

p = True
q = False

formula1 = (not p) && (p ==> q) <=> not (q && (not p))

-- 2.2 Logical Validity and Related Notions -- page 38/49

-- Truth Table of an Expression
-- If an expression contains n letters P, Q, . . ., then there are 2 n possible
-- distributions of the truth values between these letters.
-- The 2^n -row table that contains the calculations of these values is
-- the truth table of the expression

-- Example 2.5
formula2 p q = ((not p) && (p ==> q) <=> (q && (not p)))

booleanSet = [(True,True),(True,False),(False,True),(False,False)]

valid1 :: (Bool -> Bool) -> Bool
valid1 boolfun = (boolfun True) && (boolfun False)

excluded_middle :: Bool -> Bool
excluded_middle p = p || not p

valid2 :: (Bool -> Bool -> Bool) -> Bool
valid2 bf = (bf    True  True)
            && (bf True  False)
            && (bf False True)
            && (bf False False)
-- now we can run: valid2 formula2

form1 p q = p ==> (q ==> p)
form2 p q = (p ==> q) ==> p

valid3 :: (Bool -> Bool -> Bool -> Bool) -> Bool
valid3 bf = and [ bf p q r | p <- [True,False],
                  q <- [True,False],
                  r <- [True,False]]

valid4 :: (Bool -> Bool -> Bool -> Bool -> Bool) -> Bool
valid4 bf = and [ bf p q r s | p <- [True,False],
                  q <- [True,False],
                  r <- [True,False],
                  s <- [True,False]]

-- Example 2.6 page 43/54
-- perhaps I should redo it manually

-- Example 2.7 page 43/54


-- Example 2.8 page 43/54

-- Exercise 2.9 page 44/55

logEquiv1 :: (Bool -> Bool) -> (Bool -> Bool) -> Bool
logEquiv1 bf1 bf2 =
  (bf1 True <=> bf2 True) && (bf1 False <=> bf2 False)

logEquiv2 :: (Bool -> Bool -> Bool) -> (Bool -> Bool -> Bool) -> Bool
logEquiv2 bf1 bf2 =
  and [(bf1 p q) <=> (bf2 p q) | p <- [True,False], q <- [True,False]]

logEquiv3 :: (Bool -> Bool -> Bool -> Bool) ->
             (Bool -> Bool -> Bool -> Bool) -> Bool
logEquiv3 bf1 bf2 =
  and [(bf1 p q r) <=> (bf2 p q r) | p <- [True,False],
       q <- [True,False],
       r <- [True,False]]

formula3 p q = p
formula4 p q = (p <+> q) <+> q
formula5 p q = p <=> ((p <+> q) <+> q) -- formulas 3 and 4 together

-- pages 45-46 / 56-57
-- Theorem 2.10
-- handy rules -

-- ≡ equivalent
-- ∧ and
-- ∨ or
-- ¬ not
-- ⇔ iff
-- ⇒ implies

-- Exercise 2.11 page 46/57
-- redo exercise manually

test1 = logEquiv1 id (\p -> not(not p)) -- id = identical?
-- many other tests
test9b = logEquiv3 (\ p q r -> p || (q && r))
         (\ p q r -> (p || q) && (p || r))

-- Exercise 2.13 page 48/59
-- figure 2.1 on page xx/58 gives the clue
-- replace 1 with actual code
tst1a = not True <=> False
tst1b = not False <=> True
tst2  = logEquiv1 (\p -> p ==> False)  (\p -> not p)
tst3a = logEquiv1 (\p -> p || True) (\p -> True) -- could use constant function insteadof 2nd lambda
tst3b = logEquiv1 (\p -> p && False) (const False) -- constant function
tst4a = logEquiv1 (\p -> p || False) (\p -> p)
tst4b = logEquiv1 (\p -> p && True) (\p -> p)
tst5  = logEquiv1 (\p -> p || (not p)) (const True)
tst6  = logEquiv1 (\p -> p && (not p)) (const False)

-- perhaps I should skip the rest of the chapter and go to Chapter 3 page 71/82==
