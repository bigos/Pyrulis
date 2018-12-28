module Main

main : IO()
main = do
  putStrLn "Tell me your name"
  yourName <- getLine
  putStrLn ("Your name is: " ++ yourName)
