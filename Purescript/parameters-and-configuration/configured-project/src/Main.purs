module Main where

import Prelude

import Data.Traversable
import Data.Maybe (Maybe)
import Effect (Effect)
import Effect.Console (log)
import Web.DOM.Element (getAttribute)
import Web.HTML (window)
import Web.HTML.HTMLDocument (currentScript)
import Web.HTML.HTMLScriptElement as HTMLScript
import Web.HTML.Window (Window, document)

type TagInsertionConfig =
  { endpoint :: Maybe String
  , apiKey :: Maybe String
  }

--readConfig :: Window -> Effect TagInsertionConfig
readConfig win = do
  script <- currentScript =<< document win
  traverse go script
  where
  go script = do
    { endpoint: getAttribute "data-my-app--api-endpoint" elem
    , apiKey: getAttribute "data-my-app--api-key" elem
    }
    where
    elem = HTMLScript.toElement script

main :: Effect Unit
main = do
  w <- window
  config <- readConfig w
  log "Hello, start adding some code."
  log (show config)

-- https://dicioccio.fr/how-i-write-purescript-apps-part-iii.html
