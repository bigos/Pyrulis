module Main
{- colours
  Types are blue.
  Data constructors (values) are red.
  Plain functions are green.
  Variables are magenta.
-}

enterownia : String -> String
enterownia a = ("you have entered " ++ a ++ "\n")

main : IO ()
main = repl "Enter something " enterownia
