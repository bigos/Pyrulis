module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Effect.Exception (throw)
import Web.DOM.Element (getAttribute, id, toNode)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  -- https://book.purescript.org/chapter8.html
  w <- window
  doc <- document w
  ctr <- getElementById "script_with_flags" $ toNonElementParentNode doc
  case ctr of
    Nothing ->
      throw "Container element not found."
    Just el ->
      do
        s <- getAttribute "id" el
        case s of
          Nothing ->
            throw "no id attribute"
          Just idAttr ->
            log (show idAttr)
        flags <- getAttribute "data-flags" el
        case flags of
          Nothing ->
            throw "no data-flags"
          Just flagsAttr ->
            log (show flagsAttr)
