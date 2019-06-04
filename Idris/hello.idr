module Main
{- colours
  Types are blue.
  Data constructors (values)  are red.
  Functions are green.
  Variables are magenta.
-}

-- running from the terminal
-- idris --exec main ./hello.idr

record Model where
  constructor MkModel
  comId : Int
  ent : String

showModel : Model -> String
showModel model = (show (comId model)) ++ "  " ++ (show (ent model))

mainLoop : Model -> IO ()
mainLoop model = do
  putStr "Enter something "
  rrr <- getLine
  if rrr == ""
  then do
       putStrLn "aha"
       putStrLn (showModel model)
       pure ()
  else do
      putStrLn "you have entered"
      putStrLn (show rrr)
      mainLoop (MkModel ((comId model) + 1) rrr)


main : IO ()
main = do
  mainLoop (MkModel 0 "")
  putStrLn ""
  putStrLn "finished"
