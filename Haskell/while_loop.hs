module Main where

import Control.Monad
import Data.IORef

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
    readIORef global >>= (\x-> putStrLn ("doing " ++ (show x)))
    modifyIORef global (+1)
  putStrLn "finished"
  readIORef global >>= (\x-> putStrLn (show x))
