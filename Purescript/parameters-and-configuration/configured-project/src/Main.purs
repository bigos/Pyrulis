module Main where

import Prelude

import Data.Maybe (Maybe(..), fromMaybe)
import Data.Traversable (traverse)
import Data.Tuple as Tuple

import Effect.Console as Console
import Effect (Effect)
import Effect.Console (log)

import Web.DOM.Element (getAttribute)
import Web.HTML.HTMLDocument (currentScript)
import Web.HTML.HTMLScriptElement as HTMLScript
import Web.HTML.Window (Window, document)

import Web.DOM.ParentNode (QuerySelector(..))
import Web.HTML (window)
import Web.HTML.Window (Window, localStorage)
import Web.Storage.Storage (Storage, getItem, setItem)

type TagInsertionConfig =
  { endpoint :: Maybe String
  , apiKey :: Maybe String
  }

readConfig :: Effect TagInsertionConfig
readConfig = do
  w <- window
  script <- currentScript =<< w
  traverse go script
  where
  go script = do
    let elem = HTMLScript.toElement script
    pure
      { endpoint: getAttribute "data-my-app--api-endpoint" elem
      , apiKey:
          getAttribute "data-my-app--api-key" elem
      }

main :: Effect Unit
main = do
  config <- readConfig
  log "Hello, start adding some code."
  log (show config)

-- https://dicioccio.fr/how-i-write-purescript-apps-part-iii.html
