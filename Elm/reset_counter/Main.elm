module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }


type alias Model =
    { counter : Int }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { counter = 0 }, Cmd.none )


type Msg
    = Increment
    | Decrement
    | Reset



-- counter with limited counting


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            if model.counter < 5 then
                ( { model | counter = model.counter + 1 }, Cmd.none )

            else
                update Reset model

        Decrement ->
            if model.counter > -5 then
                ( { model | counter = model.counter - 1 }, Cmd.none )

            else
                update Reset model

        Reset ->
            ( { model | counter = 0 }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.counter) ]
        , button [ onClick Increment ] [ text "+" ]
        , div [] [ button [ onClick Reset ] [ text "reset" ] ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
