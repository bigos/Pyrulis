module Main where

import Prelude

import App.Counter as Counter
import Control.Monad.Error.Class (throwError)
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Console (log)
import Effect.Exception (error, throw)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Web.DOM.Element (getAttribute)
import Web.DOM.NonElementParentNode (getElementById)
import Web.DOM.ParentNode (QuerySelector(..))
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.HTMLElement (HTMLElement)
import Web.HTML.Window (document)

type TagDataConfig =
  { api_endpoint :: Maybe String
  , api_key :: Maybe String
  , start :: Maybe String
  }

-- ========== configuration =================================
-- elementName
-- name of the tag on id for the output, ou can use "body"
-- configTagid
-- ID of the tag with data attributes used for configuration
-- buildConfig
-- function that reads from the data attributes

-- this uses Elm like widget in a div, allowing me to mix PureScript with Rails generated views
awaitElement :: Aff HTMLElement
awaitElement = do
  element <- HA.selectElement (QuerySelector elementName)
  maybe (throwError (error ("could not find the expected element " <> elementName))) pure (element)
  where
  elementName = "#halogen"

main :: Effect Unit
main = do
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
  where -- configured data
  configTagId = "script_with_flags"

  buildConfig element =
    ( { api_endpoint: _, api_key: _, start: _ }
        <$> getAttribute "data-my-app--api-endpoint" element
        <*> getAttribute "data-my-app--api-key" element
        <*> getAttribute "data-my-app--count-start" element
    )
