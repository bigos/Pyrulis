module Main where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect (Effect)
import Effect.Console (log)
import Effect.Console (log)
import Prelude
import Web.HTML (window)
import Web.HTML.Window (document)
import Web.DOM.ParentNode as PN
import Web.HTML.HTMLDocument as HD

main :: Effect Unit
main = do
  win <- window
  doc <- document win
  mEl <- PN.querySelector "#script_with_flags" (HD.toDocument doc)
  case mEl of
    Just el -> log "Found the element!"
    Nothing -> log "No element found."
