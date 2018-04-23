-- input with prompt that works on Windows 10 Eshell

import System.IO (hSetBuffering, stdout, stdin, BufferMode(..))

main = do
  hSetBuffering stdin LineBuffering
  hSetBuffering stdout LineBuffering

  putStrLn "Enter a string"
  ln <- getLine
  putStrLn ("Yo have entered " ++ ln)
