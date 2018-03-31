-- example

f :: Integral a => a -> Bool
f a = mod a 2 == 0

g :: Bool -> [Char]
g b = if b then "True" else "False"

composed :: Integral a => a -> [Char]
composed = g . f

-- composed 2 -- True
-- composed 3 -- False

main :: IO ()
main = do
  mapM_ (\x -> putStrLn x) [(composed 2),
                            (composed 3)]
