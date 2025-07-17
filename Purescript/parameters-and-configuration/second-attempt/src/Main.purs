module Main where

import Prelude

import Control.Monad.Error.Class (throwError)
import Data.Maybe (Maybe(..))
import Data.Maybe (maybe)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Exception (error)
import Halogen.Aff as HA
import Web.DOM.ParentNode (QuerySelector(..), querySelector)
import Web.HTML (window)
import Web.HTML.HTMLDocument as HD
import Web.HTML.Window (document)

elementName :: String
elementName = "#script_with_flags"

findElement =
  HA.selectElement (QuerySelector elementName)

main :: Effect Unit
main = do
  HA.awaitLoad
  windoc <- document window
  -- Effect HTMLDocument
  -- but we need HTMLDocument without Effect
  w2 <- windoc
  script <- HD.currentScript w2
  pure ""
