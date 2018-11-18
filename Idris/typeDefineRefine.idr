module Main

describeList : List Int -> String
describeList [] = "Empty"
describeList (x :: xs) = "Non-empty, tail = " ++ show xs

allLengths : List String -> List Nat
allLengths [] = []
allLengths (word :: words) = length word :: allLengths words

xor: Bool -> Bool -> Bool
xor False y = y
xor True y = not y

isEven : Nat->Bool
isEven Z = True
isEven (S k) = not (isEven k)
