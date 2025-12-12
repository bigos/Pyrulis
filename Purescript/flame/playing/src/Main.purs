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
import Data.String (joinWith)
import Web.DOM.Element (getAttribute)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

type Model =
  { counter :: Int
  , board :: Array (Array Field)
  }

type Flags = { counter_start :: Maybe String }

data Message = Increment | Decrement | Initialize Flags

data Field = Field_o | Field_x | Field_empty

init ∷ Model
init = { counter: 0, board: initBoard }

initBoard = [ initRow, initRow, initRow ]
initRow = [ Field_empty, Field_empty, Field_empty ]

printBoard :: Array (Array Field) -> String
printBoard b = joinWith "--" $ map (\r -> printRow r) b

printRow :: Array (Field) -> String
printRow r = joinWith "" $ map (\c -> printField c) r

printField :: Field -> String
printField f = case f of
  Field_empty -> "+"
  Field_o -> "o"
  Field_x -> "x"

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
      { counter: flagsCounter flags
      }
    Increment -> FAE.diff
      { counter: model.counter + 1
      }
    Decrement -> FAE.diff
      { counter: model.counter - 1
      }

bgColor :: Int -> String
bgColor counter = if counter < 0 then "red" else "lime"

view ∷ Model → Html Message
view model = HE.main "main"
  [ HE.div [ HA.styleAttr "color: black" ]
      [ HE.button [ HA.onClick Decrement ] "-"
      , HE.span
          [ HA.styleAttr
              ( "background-color: "
                  <> (bgColor model.counter)
                  <> "; "
                  <> "margin: auto 1em;"
              )
          ]
          [ HE.text (show model.counter) ]
      , HE.button [ HA.onClick Increment ] "+"
      , HE.p [ HA.styleAttr "color: red" ] [ HE.text "1" ]
      , HE.p_
          [ HE.text (show (printBoard model.board))
          ]
      , HE.table_
          ( map
              ( \r ->
                  HE.tr_
                    ( map
                        ( \c ->
                            HE.td [ HA.styleAttr "color: green; border: solid 1px; padding:2em;" ]
                              [ HE.text (printField c) ]
                        )
                        r
                    )
              )
              model.board
          )
      ]

  ]

main ∷ Effect Unit
main = do
  let outputTag = "#flame"
  let configTagId = "flame_flags"
  w <- window
  doc <- document w
  config_container <- getElementById configTagId $ toNonElementParentNode doc
  case config_container of
    Nothing ->
      throw "config_container element not found"
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
