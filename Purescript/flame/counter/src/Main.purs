-- | Counter example using side effects free updating
module Main where

import Prelude

import Affjax.ResponseFormat as AR
import Affjax.Web as A
import Data.Either (Either(..))
import Data.Int (fromString)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import Flame (QuerySelector(..), Html, (:>))
import Flame.Application.Effectful (AffUpdate)
import Flame.Application.Effectful as FAE
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Web.DOM.Element (getAttribute)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

type Model =
  { url ∷ String
  , result ∷ Result
  , counter :: Int
  }

type Flags =
  { counter_start :: Maybe String
  }

data Message = UpdateUrl String | Fetch | Increment | Decrement | Initialize Flags

data Result = NotFetched | Fetching | Ok String | Error String

derive instance eqResult ∷ Eq Result

init ∷ Model
init =
  { url: "https://httpbin.org/get"
  , result: NotFetched
  , counter: 0
  }

flagsCounter :: Flags -> Int
flagsCounter flags =
  ( case flags.counter_start of
      Nothing -> (-10)
      Just flag2 ->
        ( case (fromString flag2) of
            Nothing -> (-5)
            Just val -> val
        )
  )

update ∷ AffUpdate Model Message
update { display, model, message } =
  case message of
    Initialize flags -> FAE.diff
      { url: model.url
      , result: model.result
      , counter: flagsCounter flags
      }
    UpdateUrl url → FAE.diff
      { url, result: NotFetched }
    Fetch → do
      display $ FAE.diff' { result: Fetching }
      response ← A.get AR.string model.url
      FAE.diff <<< { result: _ } $ case response of
        Left error → Error $ A.printError error
        Right payload → Ok payload.body
    Increment -> FAE.diff
      { url: model.url, result: model.result, counter: model.counter + 1 }
    Decrement -> FAE.diff
      { url: model.url, result: model.result, counter: model.counter - 1 }

bgColor :: Int -> String
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

main ∷ Effect Unit
main = do
  let outputTag = "#flame"
  let configTagId = "flame_flags"
  w <- window
  doc <- document w
  container <- getElementById configTagId $ toNonElementParentNode doc
  case container of
    Nothing ->
      throw "container element not found"
    Just element ->
      do
        flags <- buildFlags
        FAE.mount_
          (QuerySelector outputTag)
          { init: init :> (Just (Initialize flags))
          , subscribe: []
          , update
          , view
          }
      where
      buildFlags :: Effect Flags
      buildFlags =
        ( { counter_start: _ }
            <$> getAttribute "data-counter-start" element

        )
