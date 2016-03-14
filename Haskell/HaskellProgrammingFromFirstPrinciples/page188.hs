-- page 188
module Sing where

fstString :: [Char] -> [Char]
fstString x = x ++ " in the rain"

sndString :: [Char] -> [Char]
sndString x = x ++ " over the rainbow"

sing a b = if (a > b) then fstString x else sndString y
  where x = "Singin"
        y = "Somewhere"
