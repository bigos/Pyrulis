module PhotoGrooveTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode as Decode exposing (decodeValue)
import Json.Encode as Encode
import PhotoGroove exposing (Model, Msg(..), Photo, initialModel, update)
import Test exposing (..)


decoderTest : Test
decoderTest =
    fuzz2 string int "title defaults to (untitled)" <|
        \url size ->
            [ ( "url", Encode.string url ), ( "size", Encode.int size ) ]
                |> Encode.object
                |> decodeValue PhotoGroove.photoDecoder
                |> Result.map .title
                |> Expect.equal
                    (Ok "(untitled)")


slideHueSetHue : Test
slideHueSetHue =
    fuzz int "SlideHue sets the hue" <|
        \amount ->
            initialModel
                |> update (SlideHue amount)
                |> Tuple.first
                |> .hue
                |> Expect.equal amount


sliders : Test
sliders =
    describe "Slider sets the desired field in the Model"
        [ testSlider "SlideHue" SlideHue .hue
        , testSlider "SlideRipple" SlideRipple .ripple
        , testSlider "SlideNoise" SlideNoise .noise
        ]


testSlider : String -> (Int -> Msg) -> (Model -> Int) -> Test
testSlider description toMsg amountFromModel =
    fuzz int description <|
        \amount ->
            initialModel
                |> update (toMsg amount)
                |> Tuple.first
                |> amountFromModel
                |> Expect.equal amount
