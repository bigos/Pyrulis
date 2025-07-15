module Main where

import Prelude

import App.Counter as Counter
import Control.Monad.Error.Class (throwError)
import Data.Maybe (Maybe, maybe)
import Effect (Effect)
import Effect.Aff (Aff, effectCanceler, makeAff, nonCanceler, runAff_)
import Effect.Exception (throwException, error)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Web.DOM.ParentNode (QuerySelector(..), querySelector)
import Web.HTML.HTMLElement (HTMLElement)

-- this uses Elm like widget in a div, allowing me to mix PureScript with Rails generated views
awaitElement :: Aff HTMLElement
awaitElement = do
  HA.awaitLoad
  element <- HA.selectElement (QuerySelector elementName)
  maybe (throwError (error ("could not find the expected element " <> elementName))) pure element
  where
  elementName = "#halogen"

main :: Effect Unit
main = HA.runHalogenAff do
  HA.awaitLoad
  element <- awaitElement
  runUI Counter.component unit element
