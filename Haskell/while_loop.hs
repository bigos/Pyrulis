module Main where

import Control.Monad
import Data.IORef
import System.IO

initGlobal :: IO (IORef Integer)
initGlobal = newIORef 1

-- while loop using imperative global values
while :: Monad m => m Bool -> m () -> m ()
while cond action = do
  c <- cond
  if c then do
    action
    while cond action
  else return ()

main :: IO ()
main = do
  global <- initGlobal
  readIORef global >>= (\x-> putStrLn ("initial " ++ (show x)))
  while (liftM (< 10) (readIORef global)) $ do
    x <- readIORef global
    putStrLn ("doing " ++ (show x))
    putStr "enter  diff "
    hFlush stdout               -- make sure prompt displays at the right time
    diff <- getLine
    let diffInteger = read diff :: Integer
    readIORef global >>= (\m -> writeIORef global (m + diffInteger))
    -- modifyIORef global (\y -> y + diffInteger)
  putStrLn "finished"
  readIORef global >>= (\x-> putStrLn (show x))
