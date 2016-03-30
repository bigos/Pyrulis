-- chapter 6 scribbling


data TisAnInteger =
  TisAnInteger'

instance Eq TisAnInteger where
  (==) TisAnInteger' TisAnInteger' = True


data TwoIntegers =
  Two Integer Integer
  deriving (Eq)
-- instance Eq TwoIntegers where
--   (==) TwoIntegers' TwoIntegers' = True
--   (==) _ _ = False
-- data StringOrInt =
-- TisAnInt Int
-- | TisAString String
-- data Pair a =
-- Pair a a
-- data Tuple a b =
-- Tuple a b
-- data Which a =
-- ThisOne a
-- | ThatOne a
-- data EitherOr a b =
-- Hello a
-- | Goodbye b
