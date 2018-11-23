module Main

data EscString = Escape String Nat

-- assign escape code to a string
wrap : String -> Nat -> EscString
wrap s n = Escape s n

-- convert escaped string to regular string
show : EscString -> String
show (Escape s c) = (escOn c) ++ s ++ escOff
  where escOn c = "\ESC[" ++ (the String (cast c)) ++ "m"
        escOff = "\ESC[m"

main : IO ()
main = do
  putStr (show (wrap "ab" 31))
  putStr (show (wrap "cd" 32))
  putStr (show (wrap "ef" 33))
  putStrLn ""
