module Main

import Control.App
import Control.App.Console

hello : Console es => App es ()
hello = putStrLn "Hello, App world"

main : IO ()
main = run hello

-- example from
-- https://idris2.readthedocs.io/en/latest/app/introapp.html
