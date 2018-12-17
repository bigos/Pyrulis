module Main

dirName : String
dirName = "/home/jacek/Documents/"

dodir : Directory -> IO ()
dodir d = do
  dx <- dirEntry d
  case dx of
    Left  de => putStrLn "err de"
    Right sn => putStrLn sn

main : IO ()
main = do
  putStrLn "Dir list"
  dhx <- dirOpen dirName
  case dhx of
    Left er => putStrLn "error dhx"
    Right d => dodir d
  putStrLn "the end"
