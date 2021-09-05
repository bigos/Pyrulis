-- use data or newtype to create Monad class instance
import Data.List

newtype M a  = Nothing

instance Monad M where
  return x = [x]
  xs >>= f = concat (fmap f xs)

main :: IO ()
main = do
  putStrLn "monad will go here."


-- https://www.schoolofhaskell.com/school/starting-with-haskell/basics-of-haskell/13-the-list-monad#handcrafted-list-monad
