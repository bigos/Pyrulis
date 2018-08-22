module Main where

data Morse = Ti | Taa deriving (Eq, Show, Read)

-- in repl try this opposite of read:
-- (read $ mag ".") :: Morse

mag :: String -> String
mag "." = "Ti"
mag "-" = "Taa"
mag _   = error "wrong char"

magStr :: String -> [String]
magStr s = map (\c-> mag [c]) s

titawa :: String -> [Morse]
titawa s = map (\c-> read $ mag [c]) s

cm :: Char -> [Morse]
cm c = ggg c
  where ggg 'a' = titawa ".-"
        ggg 'k' = titawa "-.-"
        ggg _   = error "Not implemented character"

mc m = ggg m
  where ggg [Ti,Taa] = 'a'
        ggg [Taa,Ti,Taa] = 'k'
        ggg _ = error "not implemented signal"

main :: IO ()
main = do
  putStrLn "hello world"
