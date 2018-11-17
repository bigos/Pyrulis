module Main
{- colours
  Types are blue.
  Data constructors (values)  are red.
  Functions are green.
  Variables are magenta.
-}

enterownia : String -> String
enterownia a = ("you have entered " ++ a ++ "\n")

main : IO ()
-- main = putStrLn "Hello Idris!"
main = repl "Enter something " enterownia
