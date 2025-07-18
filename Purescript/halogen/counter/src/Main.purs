module Main where

import Prelude

import App.Counter as Counter
import Control.Monad.Error.Class (throwError)
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Effect.Exception (error, throw)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Web.DOM.Element (getAttribute)
import Web.DOM.NonElementParentNode (getElementById)
import Web.DOM.ParentNode (QuerySelector(..))
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

{-
========== configuration =================================
* elementName
name of the tag or the ID for the output, it can use "body" for pull page app
here we use #halogen because we place output in a div with id halogen
* configTagid
ID of the tag with data attributes used for configuration
* buildConfig
function that reads from the data
-}

main :: Effect Unit
main = do
  let elementName = "#halogen"
  let configTagId = "script_with_flags"
  w <- window
  doc <- document w
  container <- getElementById configTagId $ toNonElementParentNode doc
  case container of
    Nothing ->
      throw "container element not found"
    Just el ->
      do
        config <- buildConfig el
        HA.runHalogenAff do
          _ <- HA.awaitBody
          element <- awaitElement
          runUI Counter.component config element
      where
      awaitElement = do
        element <- HA.selectElement (QuerySelector elementName)
        maybe (throwError (error ("could not find the expected element " <> elementName))) pure (element)
      -- function that reads the data from the config tag attributes
      buildConfig element =
        ( { api_endpoint: _, api_key: _, start: _ }
            <$> getAttribute "data-my-app--api-endpoint" element
            <*> getAttribute "data-my-app--api-key" element
            <*> getAttribute "data-my-app--count-start" element
        )
