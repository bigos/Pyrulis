module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { counter : Int }


init : Model
init =
    { counter = 0 }


type Msg
    = Increment
    | Decrement
    | Reset



-- counter with limited counting


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            if model.counter < 5 then
                { model | counter = model.counter + 1 }

            else
                update Reset model

        Decrement ->
            if model.counter > -5 then
                { model | counter = model.counter - 1 }

            else
                update Reset model

        Reset ->
            { model | counter = 0 }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.counter) ]
        , button [ onClick Increment ] [ text "+" ]
        , div [] [ button [ onClick Reset ] [ text "reset" ] ]
        ]
