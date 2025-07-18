module App.Counter where

import Prelude

import Affjax.ResponseFormat as AXRF
import Affjax.Web as AX
import Data.Either (hush)
import Data.Int (fromString)
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

type State = { count :: Int, loading :: Boolean, result :: Maybe String, arg :: TagDataConfig }

data Action = Increment | Decrement | MakeRequest

type TagDataConfig =
  { api_endpoint :: Maybe String
  , api_key :: Maybe String
  , start :: Maybe String
  }

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

initialState :: TagDataConfig -> State
initialState arg =
  { count:
      ( case arg.start of
          Nothing -> 0
          Just a ->
            ( case fromString a of
                Nothing -> 0
                Just av -> av
            )
      )
  , loading: false
  , result: Nothing
  , arg: arg

  }

--component :: forall q i o m. ?whatisit q i o m
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
                  , HH.p_ [ HH.text res ]

                  ]
            )
        ]
    , HH.h3_ [ HH.text "Configured values" ]
    , HH.p [] [ HH.text (show state.arg) ]

    ]

handleAction :: forall output m. MonadAff m => Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  Increment -> H.modify_ \st -> st { count = st.count + 1 }
  Decrement -> H.modify_ \st -> st { count = st.count - 1 }
  MakeRequest -> do
    H.modify_ \st -> st { loading = true }
    response <- H.liftAff $ AX.get AXRF.string
      ( "http://localhost:3000/api/get-files"
          <> "?"
          <> getArgs
      )
    H.modify_ \st -> st
      { loading = false
      , result = map _.body (hush response)
      }

  where
  getArgs =
    ( "pwd=/home/jacek/"
        <> "&"
        <> "show_hidden=true"
    )
