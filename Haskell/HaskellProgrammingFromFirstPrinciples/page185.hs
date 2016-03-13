-- page 185
-- Does it compile?

-- bigNum = (^) 5 10
-- wahoo = bigNum ^ 10

-- x = print
-- y = print "wohoo!"
-- z = x "hello world"

-- a = (+)
-- b = 5
-- c = a b 10
-- d = a c 200

-- Type variable or specific type constructor
-- page 186

-- functionH :: [a] -> a
-- functionH (x:_) = x

-- functionC :: Ord a => a -> a -> Bool
-- functionC x y = if (x > y) then True else False

-- functionS :: (a,b) -> b
-- functionS (x, y) = y


-- page 187
-- Given a type, write a function

-- have no idea how to write these exercices
i :: a -> a
i x = x

c :: a -> b -> a
c a b = concat [a, [b]]

c'' :: b -> a -> b
c'' b a = concat [b, [a]]

c' :: a -> b -> b
c' = undefined

r :: [a] -> [a]
r = undefined

co :: (b -> c) -> (a -> b) -> (a -> c)
co = undefined

a :: (a -> c) -> a -> a
a = undefined

a' :: (a -> b) -> a -> b
a' = undefined
