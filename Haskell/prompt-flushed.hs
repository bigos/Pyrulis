module Main where

import System.IO (BufferMode(LineBuffering), hFlush, hSetBuffering, stdin, stdout)

main :: IO ()
main =
  hSetBuffering stdin  LineBuffering >>
  hSetBuffering stdout LineBuffering >>
  putStr "Type something " >>
  hFlush stdout >>
  getLine >>=
  (\ln -> putStrLn ("You typed " ++ ln))
