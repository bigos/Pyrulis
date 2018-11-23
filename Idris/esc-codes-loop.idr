module Main

escWithCode : String -> Nat -> String
escWithCode str n = (escOn n) ++  str ++ escOff
  where
    escOn : Nat -> String
    escOn n = "\ESC[" ++ (the String (cast n)) ++ "m"
    escOff = "\ESC[m"

prex : Nat -> IO ()
prex c = do
  putStrLn (escWithCode ("abcef "++(the String (cast c)) ) c)
  if (c >= 38)
    then putStrLn ""
    else prex (c + 1)

main : IO ()
main = do
  putStrLn (escWithCode "going to print in loop" 30)
  prex 30                       --recursively print in a loop
  putStrLn "finish"
