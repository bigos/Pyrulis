-- inspired by https://wiki.haskell.org/State_Monad
-- https://en.wikibooks.org/wiki/Haskell/Understanding_monads/State

import Control.Monad.State

-- Example use of State monad
-- Passes a string of dictionary {a,b,c}
-- Game is to produce a number from the string.
-- By default the game is off, a C toggles the
-- game on and off. A 'a' gives +1 and a b gives -1.
-- E.g
-- 'ab'    = 0
-- 'ca'    = 1
-- 'cabca' = 0
-- State = game is on or off & current score
--       = (Bool, Int)

type GameValue = (Int, Int)

-- it is a state generator NOT state
type GameState = (Bool, GameValue)

playGame :: String -> State GameState GameValue
playGame []     = do
    (_, score) <- get
    return score

playGame (x:xs) = do
    (on, score) <- get
    case x of
         'a' | on -> put (on, ((fst score) + 1, snd score))
         'b' | on -> put (on, ((fst score) - 1, snd score))
         'c'      -> put (not on, score)
         _        -> put (on, score)
    playGame xs

startState = (False, (0,0))

main = print $ evalState (playGame "abcaaacbbcabbab") startState
