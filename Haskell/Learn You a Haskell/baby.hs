-- simple functions
doubleMe x = x + x
doubleUs x y = x * 2 + y * 2
tripleMe x = x * 3

-- using if
doubleSmallNumber x = if x > 100
                      then x
                      else x*2

-- add 1 to the result no matter if greter than 100 or not
doubleSmallNumber' x = (if x > 100 then x else x*2) + 1


-- file:///home/jacek/Documents/Manuals/Haskell/learnyouahaskell.com/starting-out

-- an intro to lists

-- string is a list of characters
testStringKind x = if x == ['h','e','l','l','o']
                   then x
                   else "not the same"
