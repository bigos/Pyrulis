module App.Counter where

import Prelude

import Affjax.Web as AX
import Affjax.ResponseFormat as AXRF
import Data.Either (hush)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Web.Event.Event (Event)
import Web.Event.Event as Event

type State = { count :: Int, loading :: Boolean, result :: Maybe String }

data Action = Increment | Decrement | MakeRequest

counter_color :: Int -> String
counter_color count =
  if count == 0 then "background: white"
  else (if count < 0 then "background: red" else "background: lime")

outer_style :: String
outer_style =
  ( "display: inline-flex;"
      <> "margin: 1em;"
      <> "padding:1em;"
      <> "background: lightcyan;"
  )

initialState :: forall input. input -> State
initialState _ = { count: 0, loading: false, result: Nothing }

component :: forall q i o m. MonadAff m => H.Component q i o m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval H.defaultEval { handleAction = handleAction }
    }

render :: forall cs m. State -> H.ComponentHTML Action cs m
render state =
  HH.div []
    [ HH.div [ HP.style outer_style, HP.class_ (HH.ClassName "first-class") ]
        [ HH.button
            [ HE.onClick \_ -> Decrement ]
            [ HH.text "-" ]

        , HH.p [ HP.style "background: white; padding: 1em" ]
            [ HH.text "You counted "
            , HH.span [ HP.style ("padding: 0.25em; " <> (counter_color state.count)) ]
                [ HH.text (show state.count) ]
            , HH.text " times"
            ]

        , HH.button
            [ HE.onClick \_ -> Increment ]
            [ HH.text "+" ]

        ]
    , HH.div
        []
        [ HH.p []
            [ HH.button
                [ HE.onClick \_ -> MakeRequest ]
                [ HH.text "Get the data" ]
            ]
        , HH.div_
            ( case state.result of
                Nothing -> []
                Just res ->
                  [ HH.h2_
                      [ HH.text "Response:"
                      ]
                  , HH.pre_ [ HH.p_ [ HH.text res ] ]
                  ]
            )
        ]
    ]

-- I have no idea what correct type signature would be
-- handleAction :: forall cs o m. Action → H.HalogenM State Action cs o m Unit
handleAction = case _ of
  Increment -> H.modify_ \st -> st { count = st.count + 1 }
  Decrement -> H.modify_ \st -> st { count = st.count - 1 }
  MakeRequest -> do
    H.modify_ _ { loading = true }
    response <- H.liftAff $ AX.get AXRF.string
      ("http://localhost:3000/api/get-files" <> "?" <> "pwd=/home/jacek/&show_hidden=true")
    H.modify_ _ { loading = false, result = map _.body (hush response) }
