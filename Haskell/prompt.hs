module Main where

import Control.Applicative
import Control.Monad

-- doesn't work in Emacs, neither intero nor the old REPL work

main :: IO ()
main =
  putStrLn "Type something"
    >> getLine
    >>= (\line -> putStrLn ("you have typed: " ++ line))
