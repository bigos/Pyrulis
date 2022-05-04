module Main exposing (..)

import Browser
import Browser.Dom as BD
import Browser.Events as BE
import Debug
import Html exposing (Html, button, div, hr, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Json.Decode as D
import Task exposing (..)
import Time exposing (..)



-- MAIN


main =
    Browser.document
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }



-- PORTS
--   empty
-- TYPES


type alias Clock =
    { time : Time.Posix, zone : Time.Zone }


type alias Resolution =
    { width : Int, height : Int }


type alias MouseData =
    { screenX : Int
    , screenY : Int
    , clientX : Int
    , clientY : Int
    , ctrlKey : Bool
    , shiftKey : Bool
    , metakey : Bool
    , button : Int
    }


type alias KeyData =
    { key : String
    , ctrlKey : Bool
    , altKey : Bool
    , metaKey : Bool
    , shiftKey : Bool
    }



-- MODEL


type alias Model =
    { count : Int
    , clock : Clock
    , resolution : Resolution
    , viewport : BD.Viewport
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { count = 0
      , clock = Clock (Time.millisToPosix 0) Time.utc
      , resolution = Resolution 0 0
      , viewport =
            { scene = { width = 0, height = 0 }
            , viewport = { x = 0, y = 0, width = 0, height = 0 }
            }
      }
    , Cmd.batch
        [ Task.perform SetClockZone Time.here
        , Task.perform SetViewportData BD.getViewport
        ]
    )



-- UPDATE


type Msg
    = Increment
    | Decrement
    | Tick Time.Posix
    | SetClockTime Time.Posix
    | SetClockZone Time.Zone
    | ResolutionChange Int Int
    | SetViewportData BD.Viewport
    | VisibilityChange BE.Visibility
    | KeyPressEvent KeyData
    | KeyDownEvent KeyData
    | KeyUpEvent KeyData
    | MouseClickEvent MouseData
    | MouseMoveEvent MouseData
    | MouseUpEvent MouseData
    | MouseDownEvent MouseData


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ( { model | count = model.count - 1 }, Cmd.none )

        Tick newTime ->
            ( { model | clock = Clock newTime model.clock.zone }, Cmd.none )

        SetClockZone newZone ->
            ( { model | clock = Clock model.clock.time newZone }, Task.perform SetClockTime Time.now )

        SetClockTime newTime ->
            ( { model | clock = Clock newTime model.clock.zone }, Cmd.none )

        ResolutionChange w h ->
            ( { model | resolution = Resolution w h }, Task.perform SetViewportData BD.getViewport )

        SetViewportData vd ->
            Debug.log (Debug.toString vd)
                ( { model
                    | viewport = vd
                    , resolution = Resolution (round vd.scene.width) (round vd.scene.height)
                  }
                , Cmd.none
                )

        VisibilityChange newVisibitlity ->
            Debug.log
                ("visibility changed "
                    ++ Debug.toString newVisibitlity
                )
                ( model, Cmd.none )

        KeyPressEvent key ->
            Debug.log ("key press " ++ Debug.toString key)
                ( model, Cmd.none )

        KeyDownEvent key ->
            Debug.log ("key down " ++ Debug.toString key)
                ( model, Cmd.none )

        KeyUpEvent key ->
            Debug.log ("key up " ++ Debug.toString key)
                ( model, Cmd.none )

        MouseClickEvent a ->
            Debug.log ("mouse click " ++ Debug.toString a)
                ( model, Cmd.none )

        MouseMoveEvent a ->
            Debug.log ("mouse move " ++ Debug.toString a)
                ( model, Cmd.none )

        MouseDownEvent a ->
            Debug.log ("mouse down " ++ Debug.toString a)
                ( model, Cmd.none )

        MouseUpEvent a ->
            Debug.log ("mouse up " ++ Debug.toString a)
                ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every 1000 Tick
        , BE.onKeyPress (D.map KeyPressEvent keyPressDecoder) --Key
        , BE.onKeyDown (D.map KeyDownEvent keyPressDecoder)
        , BE.onKeyUp (D.map KeyUpEvent keyPressDecoder)
        , BE.onClick (D.map MouseClickEvent mouseDataDecoder) --Mouse
        , if model.count > 5 then
            BE.onMouseMove (D.map MouseMoveEvent mouseDataDecoder)

          else
            Sub.none

        -- very costly - should be run only when needed
        , BE.onMouseDown (D.map MouseDownEvent mouseDataDecoder)
        , BE.onMouseUp (D.map MouseUpEvent mouseDataDecoder)
        , BE.onResize (\w h -> ResolutionChange w h) --Window
        , BE.onVisibilityChange VisibilityChange
        ]



-- events decoded are documented in:
-- https://developer.mozilla.org/en-US/docs/Web/API/Event


keyPressDecoder : D.Decoder KeyData
keyPressDecoder =
    D.map5 KeyData
        (D.field "key" D.string)
        (D.field "ctrlKey" D.bool)
        (D.field "altKey" D.bool)
        (D.field "metaKey" D.bool)
        (D.field "shiftKey" D.bool)


mouseDataDecoder : D.Decoder MouseData
mouseDataDecoder =
    D.map8 MouseData
        (D.field "screenX" D.int)
        (D.field "screenY" D.int)
        (D.field "clientX" D.int)
        (D.field "clientY" D.int)
        (D.field "ctrlKey" D.bool)
        (D.field "shiftKey" D.bool)
        (D.field "metaKey" D.bool)
        (D.field "button" D.int)



-- view


view : Model -> Browser.Document Msg
view model =
    { title =
        "This is the Elm title"
    , body =
        [ div []
            [ button [ onClick Decrement ] [ text "-" ]
            , div [] [ text (String.fromInt model.count) ]
            , button [ onClick Increment ] [ text "+" ]
            , hr [] []
            , div []
                [ text ("debugging model " ++ Debug.toString ( model, clockInfo model ))
                ]
            ]
        ]
    }


clockInfo model =
    let
        timeFn fn =
            fn model.clock.zone model.clock.time
    in
    ""
        ++ String.fromInt (timeFn Time.toHour)
        ++ ":"
        ++ String.fromInt (timeFn Time.toMinute)
        ++ ":"
        ++ String.fromInt (timeFn Time.toSecond)


decodeFraction : D.Decoder Float
decodeFraction =
    D.map2 (/)
        (D.field "pageX" D.float)
        (D.at [ "currentTarget", "defaultView", "innerWidth" ] D.float)


decodeButtons : D.Decoder Bool
decodeButtons =
    D.field "buttons" (D.map (\buttons -> buttons == 1) D.int)



-- THE END
-- file:~/Programming/simple-organizer/Elm/simple-editor/README.org
