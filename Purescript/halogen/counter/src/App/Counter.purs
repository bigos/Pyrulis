module App.Counter where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

type State
  = { count :: Int }

data Action
  = Increment | Decrement

counter_color :: Int -> String
counter_color count =
  if count == 0
  then "background: white"
  else (if count < 0
        then "background: red"
        else "background: lime")

component :: forall q i o m. H.Component q i o m
component =
  H.mkComponent
    { initialState: \_ -> { count: 0 }
    , render
    , eval: H.mkEval H.defaultEval { handleAction = handleAction }
    }

render :: forall cs m. State -> H.ComponentHTML Action cs m
render state =
  HH.div [HP.style
          (
            "display: inline-flex;" <>
            "margin: 1em;" <>
            "padding:1em;" <>
            "background: yellow;"
          )
         ,
          HP.class_ (HH.ClassName  "first-class")
         ]
  [HH.button
   [HE.onClick \_ -> Decrement]
   [HH.text "-"]
  , HH.p [HP.style "background: white; padding: 1em"]
    [HH.text "You counted "
    , HH.span [HP.style ("padding: 0.25em; " <> (counter_color state.count))]
      [HH.text (show state.count)]
    , HH.text " times"
    ]
  , HH.button
    [HE.onClick \_ -> Increment ]
    [HH.text "+" ]
  ]

handleAction :: forall cs o m. Action → H.HalogenM State Action cs o m Unit
handleAction = case _ of
  Increment -> H.modify_ \st -> st { count = st.count + 1 }
  Decrement -> H.modify_ \st -> st { count = st.count - 1 }
module App.Counter where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

type State = { count :: Int }

data Action
  = Increment
  | Decrement

counter_color :: Int -> String
counter_color count =
  if count == 0 then "background: white"
  else
    ( if count < 0 then "background: red"
      else "background: lime"
    )

component :: forall q i o m. H.Component q i o m
component =
  H.mkComponent
    { initialState: \_ -> { count: 0 }
    , render
    , eval: H.mkEval H.defaultEval { handleAction = handleAction }
    }

render :: forall cs m. State -> H.ComponentHTML Action cs m
render state =
  HH.div
    [ HP.style
        ( "display: inline-flex;"
            <> "margin: 1em;"
            <> "padding:1em;"
            <>
              "background: yellow;"
        )
    , HP.class_ (HH.ClassName "first-class")
    ]
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

handleAction :: forall cs o m. Action → H.HalogenM State Action cs o m Unit
handleAction = case _ of
  Increment -> H.modify_ \st -> st { count = st.count + 1 }
  Decrement -> H.modify_ \st -> st { count = st.count - 1 }
