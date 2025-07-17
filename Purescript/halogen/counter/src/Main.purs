module Main where

import Prelude

import App.Counter as Counter
import Control.Monad.Error.Class (throwError)
import Data.Maybe (Maybe(..))
import Data.Maybe (maybe)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Console (log)
import Effect.Exception (error)
import Effect.Exception (throw)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Web.DOM.Element (getAttribute, id, toNode)
import Web.DOM.NonElementParentNode (getElementById)
import Web.DOM.ParentNode (QuerySelector(..))
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.HTMLElement (HTMLElement)
import Web.HTML.Window (document)

-- this uses Elm like widget in a div, allowing me to mix PureScript with Rails generated views
awaitElement :: Aff HTMLElement
awaitElement = do
  HA.awaitLoad
  element <- HA.selectElement (QuerySelector elementName)
  maybe (throwError (error ("could not find the expected element " <> elementName))) pure element
  where
  elementName = "#halogen"

-- data-my-app--api-endpoint="https://example.com/"
-- data-my-app--api-key="0xdeadb33f"
-- data-count-start="12"
flagdata :: String
flagdata = "name=user--apikey=123456"

main :: Effect Unit
main = HA.runHalogenAff do
  HA.awaitLoad
  element <- awaitElement
  runUI Counter.component flagdata element

-- main :: Effect Unit
-- main = do
--   -- https://book.purescript.org/chapter8.html
--   w <- window
-- doc <- document w
-- ctr <- getElementById "script_with_flags" $ toNonElementParentNode doc
-- case ctr of
--   Nothing ->
--     throw "Container element not found."
--   Just el ->
--     do
--       s <- getAttribute "id" el
--       case s of
--         Nothing ->
--           throw "no id attribute"
--         Just idAttr ->
--           log (show idAttr)
--       flags <- getAttribute "data-flags" el
--       case flags of
--         Nothing ->
--           throw "no data-flags"
--         Just flagsAttr ->
--           log (show flagsAttr)
