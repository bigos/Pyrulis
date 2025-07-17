module Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect (Effect)
import Effect.Console (log)
import Effect.Console (log)
import Prelude
import Web.DOM (querySelector, toDocument)
import Web.HTML (window)
import Web.HTML.Window (document)

-- main :: Effect Unit
-- main = do
--   log "Hello, start adding some code."

main :: Effect Unit
main = do
  win <- window
  doc <- document win
  mEl <- querySelector "#script_with_flags" (toDocument doc)
  case mEl of
    Just el -> log "Found the element!"
    Nothing -> log "No element found."
