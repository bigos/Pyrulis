-- | Counter example using side effects free updating
module Main where

import Prelude

import Affjax.ResponseFormat as AR
import Affjax.Web as A
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Flame (QuerySelector(..), Html, (:>))
import Flame.Application.Effectful (AffUpdate)
import Flame.Application.Effectful as FAE
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Web.DOM.Element (getAttribute)
import Web.HTML.HTMLScriptElement as HTMLScript
import Web.HTML.Window (Window)
import Web.HTML.Window as Window

type Model =
  { url ∷ String
  , result ∷ Result
  , counter :: Int
  , endpoint :: String
  , apiKey :: String
  }

type TagInsertionConfig =
  { endpoint :: Maybe String
  , apiKey :: Maybe String
  }

data Message = UpdateUrl String | Fetch | Increment | Decrement

data Result = NotFetched | Fetching | Ok String | Error String

derive instance eqResult ∷ Eq Result

--init ∷ TagInsertionConfig -> Model
init config =
  { url: "https://httpbin.org/get"
  , result: NotFetched
  , counter: 0
  , endpoint: config.endpoint
  , apiKey: config.apiKey
  }

update ∷ AffUpdate Model Message
update { display, model, message } =
  case message of
    UpdateUrl url → FAE.diff { url, result: NotFetched }
    Fetch → do
      display $ FAE.diff' { result: Fetching }
      response ← A.get AR.string model.url
      FAE.diff <<< { result: _ } $ case response of
        Left error → Error $ A.printError error
        Right payload → Ok payload.body
    Increment -> FAE.diff { url: model.url, result: model.result, counter: model.counter + 1 }
    Decrement -> FAE.diff { url: model.url, result: model.result, counter: model.counter - 1 }

bgColor counter = if counter < 0 then "red" else "lime"

view ∷ Model → Html Message
view { url, result, counter } = HE.main "main"
  [ HE.button [ HA.onClick Decrement ] "-"
  , HE.span
      [ HA.styleAttr
          ( "background-color: "
              <> (bgColor counter)
              <> "; "
              <> "margin: auto 1em;"
          )
      ]
      [ HE.text (show counter) ]
  , HE.button [ HA.onClick Increment ] "+"
  , HE.br
  , HE.input [ HA.onInput UpdateUrl, HA.value url, HA.type' "text" ]
  , HE.button [ HA.onClick Fetch, HA.disabled $ result == Fetching ] "Fetch"
  , case result of
      NotFetched →
        HE.div_ "Not Fetched..."
      Fetching →
        HE.div_ "Fetching..."
      Ok ok →
        HE.pre_ <<< HE.code_ $ "Ok: " <> ok
      Error error →
        HE.div_ $ "Error: " <> error
  ]

-- readConfig :: Window -> Effect TagInsertionConfig
-- readConfig win = do
--   script <- currentScript =<< Window.document win
--   traverse go script
--   where
--   go script =
--     do
--       { endpoint:
--           getAttribute "data-my-app--api-endpoint" elem
--       , apikey:
--           getAttribute "data-my-app--api-key" elem
--       }
--     where
--     elem = HTMLScript.toElement script

--readConfig2 :: Effect TagInsertionConfig
readConfig2 =
  { endpoint:
      "user"
  , apikey:
      "1234"
  }

-- no luck trying to pass arguments to init
main ∷ Effect Unit
main = do
  -- w <- window
  FAE.mount_ (QuerySelector "#flame")
    { init: (init readConfig2)
    , subscribe: []
    , update
    , view
    }
