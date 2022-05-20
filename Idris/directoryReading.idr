module Main

dirName : String
dirName = "/home/jacek/Documents/"

listDir : Directory -> List String -> IO (List String)
listDir d  ls = do
  dx <- dirEntry d
  case dx of
    Left  de => pure ls         --no more entries, return the list
    Right sn => listDir d (sn :: ls)

main : IO ()
main = do
  putStrLn ("Listing directory " ++ dirName)
  dh <- dirOpen dirName
  case dh of
    Left er => putStrLn "directory not found"
    Right d => do
      entries <- listDir d []
      putStrLn (show entries)
      putStrLn "done"

-- Local Variables:
-- idris2-load-packages: ("test-0.5.1" "support" "network-0.5.1" "linear-0.5.1" "lib" "docs" "contrib-0.5.1" "base-0.5.1" "prelude-0.5.1")
-- End:
