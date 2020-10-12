{-# LANGUAGE FlexibleInstances, UndecidableInstances, DuplicateRecordFields #-}

module Main where

import Control.Monad
import Data.Array
import Data.Bits
import Data.List

import Data.Set
import Debug.Trace
import System.Environment
import System.IO
import System.IO.Unsafe

data SinglyLinkedListNode = SinglyLinkedListNode {
    nodeData :: Int,
    next :: SinglyLinkedListNode
} | SinglyLinkedListNodeNil

createSinglyLinkedList :: [Int] -> SinglyLinkedListNode
createSinglyLinkedList [] = SinglyLinkedListNodeNil
createSinglyLinkedList (x:xs) = SinglyLinkedListNode {
    nodeData = x,
    next = createSinglyLinkedList xs
}

instance {-# OVERLAPPING #-} Show (SinglyLinkedListNode, String) where
    show (SinglyLinkedListNodeNil, _) = ""
    show (SinglyLinkedListNode x SinglyLinkedListNodeNil, _) = show x
    show (SinglyLinkedListNode x xs, sep) = show x ++ sep ++ show(xs, sep)

-- Complete the reversePrint function below.

--
-- For your reference:
--
-- SinglyLinkedListNode {
--     nodeData :: Int
--     next :: SinglyLinkedListNode
-- }
--
--

reversePrint :: SinglyLinkedListNode -> IO ()
reversePrint SinglyLinkedListNodeNil = return ()
reversePrint llist = do
    reversePrint (next llist)
    putStrLn (show (nodeData llist))



readMultipleLinesAsStringArray :: Handle -> Int -> IO [String]
readMultipleLinesAsStringArray handle 0 = return []
readMultipleLinesAsStringArray handle n = do
  line <- hGetLine handle
  rest <- readMultipleLinesAsStringArray handle (n - 1)
  return (line : rest)

-- got shell output with
-- cat ./input0.txt | stack runhaskell ./solution.hs
main :: IO ()
main = do
  let fromStdin = False --True or False
  handle <- if fromStdin then pure stdin else openFile "./input0.txt" ReadMode
  --line <- hGetLine handle

  tests2 <- hGetLine handle
  let tests = read tests2

  forM_ [1..tests] $ \tests_itr -> do
    nnn <- hGetLine handle
    let llistTempCount = read nnn

    llistTempTemp <- readMultipleLinesAsStringArray handle llistTempCount
    let llistTemp = Data.List.map (read :: String -> Int) llistTempTemp

    let llist = createSinglyLinkedList llistTemp
    reversePrint llist
  hClose handle
