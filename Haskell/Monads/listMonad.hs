-- use data or newtype to create Monad class instance

newtype M a = M (String -> (a, String))

instance Monad M where
  return a = M (\x -> (a, x))
  m >>= k  = --how do i define bind?

main :: IO ()
main = do
  putStrLn "monad will go here."


-- https://stackoverflow.com/questions/26517061/define-a-new-monad-in-haskell
