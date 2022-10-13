module Main exposing (..)

import Browser
import Decimal exposing (..)
import Html exposing (Html, button, div, hr, text)
import Html.Events exposing (onClick)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    Decimal


init : Model
init =
    Maybe.withDefault (Decimal.fromInt 50) (Decimal.fromFloat 1.0)



-- UPDATE


type Msg
    = Increment
    | Decrement


decz10 =
    case Decimal.fromFloat 0.1 of
        Just v ->
            v

        Nothing ->
            Decimal.fromInt 0


decz5 =
    case Decimal.fromFloat 0.05 of
        Just v ->
            v

        Nothing ->
            Decimal.fromInt 0


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            Decimal.add model decz10

        Decrement ->
            Decimal.sub model decz5



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (Decimal.toString model) ]
        , button [ onClick Increment ] [ text "+" ]
        , hr [] []
        , div [] [ text <| Decimal.toString (Decimal.mul model (Decimal.fromInt 2)) ]
        , div [] [ text <| Decimal.toString (Decimal.mul model (Decimal.fromInt 3)) ]
        ]
