module PhotoGrooveTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode as Decode exposing (decodeString, decodeValue)
import Json.Encode as Encode
import PhotoGroove
import Test exposing (..)


decoderTest : Test
decoderTest =
    test "title defaults to (untitled)" <|
        \_ ->
            -- """{"url": "fruits.com", "size":5}"""
            [ ( "url", Encode.string "fruits .com" ), ( "size", Encode.int 5 ) ]
                |> Encode.object
                |> decodeValue PhotoGroove.photoDecoder
                |> Result.map .title
                |> Expect.equal
                    (Ok "(untitled)")
