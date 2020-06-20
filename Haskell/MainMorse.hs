module Main where

data Morse = Ti | Ta deriving (Eq, Show, Read)
type MLetter = [Morse]
type MDat = (String, String)

mr :: Char -> Morse
mr '.' = Ti
mr '-' = Ta
mr _   = error ("Morse can be only " ++ st Ti ++ " or " ++ st Ta)

st :: Morse -> String
st Ti = "."
st Ta = "-"

m2l :: MLetter -> String
m2l mlt = fst $ head $ filter (\x -> snd x == mlt) mdat

l2m :: String -> MLetter
l2m str = snd $ head $ filter (\x -> fst x == str) mdat

word2m :: String -> [MLetter]
word2m str = map (\c-> l2m [c]) str

mdat :: [(String, MLetter)]
mdat = map (\z -> (lp z, sp z) ) dat
  where
    lp z = head $ words z
    sp z = map mr $ words z!!1

sdat :: [(String, String)]
sdat = map (\z -> (lp z, sp z) ) dat
  where
    lp z = head $ words z
    sp z = words z !! 1

ms2cs :: [String] -> String
ms2cs msa = foldl (++) "" $ map (m2l . map mr) msa

dat :: [String]
dat = ["A .-",      "B -...",   "C -.-.",   "D -..",
       "E .",       "F ..-.",   "G --.",    "H ....",
       "I ..",      "J .---",   "K -.-",    "L .-..",
       "M --",      "N -.",     "O ---",    "P .--.",
       "Q --.-",    "R .-.",    "S ...",    "T -",
       "U ..-",     "V ...-",   "W .--",    "X -..-",
       "Y -.--",    "Z --..",   "0 -----",  "1 .----",
       "2 ..---",   "3 ...--",  "4 ....-",  "5 .....",
       "6 -....",   "7 --...",  "8 ---..",  "9 ----.",
       ". .-.-.-",  ", --..--", ": ---...", "? ..--..",
       "' .----.",  "- -....-", "/ -..-.",  "( -.--.-",
       "\" .-..-.", "@ .--.-.", "= -...-",  "Err ........"]

main :: IO()
main =
  putStrLn $ "SOS is "  ++ show ( word2m "SOS")
