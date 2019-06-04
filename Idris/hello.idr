module Main
{- colours
  Types are blue.
  Data constructors (values) are red.
  Plain functions are green.
  Variables are magenta.
-}

-- running from the terminal
-- idris --exec main ./hello.idr

import System

main : IO ()
main = do
  returnCode <- System.system "echo 'this is echo'"
  putStrLn (show returnCode)
