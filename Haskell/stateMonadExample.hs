-- inspired by https://wiki.haskell.org/State_Monad

import Control.Monad.State

type GameValue = Int
type GameState = (String, Int)

playGame :: [Int] -> State GameState GameState
playGame []     = do
    (s, score) <- get
    return (s, score)

playGame (x:xs) = do
    (on, score) <- get
    put ((on ++ (show x)), score + x)
    playGame xs

startState = ("", 0)

main = print $ evalState (playGame [1,2,3,4]) startState
