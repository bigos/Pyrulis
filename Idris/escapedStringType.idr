module Main

data EscString = Escape String Nat

-- assign escape code to a string
wrap : String -> Nat -> EscString
wrap s n = Escape s n

-- convert escaped string to regular string
show2 : EscString -> String
show2 (Escape s c) = (escOn c) ++ s ++ escOff
  where escOn c = "\ESC[" ++ (cast c) ++ "m"
        escOff  = "\ESC[m"

strAndNum : String -> Nat -> String
strAndNum s n = s ++ " " ++ (cast n)

||| Get list of terminal escape colours with their codes
colorCodes : List (String, Nat)
colorCodes = zip names codes
  where
    names = ["black","red","green","yellow","blue","magenta","cyan","white"]
    codes = [30,31,32,33,34,35,36,37]

escapedColorsWithcodes : List String
escapedColorsWithcodes =  map show2 (map (\c => wrap (strAndNum (fst c) (snd c))(snd c) ) colorCodes)

main : IO ()
main = do
  putStrLn (show2 (wrap (strAndNum "Ax" 30) 30))
  putStrLn (show2 (wrap (strAndNum "Ax" 31) 31))
  putStrLn (show2 (wrap (strAndNum "Ax" 32) 32))
  putStrLn (show2 (wrap (strAndNum "Ax" 33) 33))
  putStrLn (show2 (wrap (strAndNum "Ax" 34) 34))
  putStrLn (show2 (wrap (strAndNum "Ax" 35) 35))
  putStrLn (show2 (wrap (strAndNum "Ax" 36) 36))
  putStrLn (show2 (wrap (strAndNum "Ax" 37) 37))
  putStrLn ""
