module PhotoGroove exposing (main)

import Array exposing (Array)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


update msg model =
    if msg.description == "Clicked photo" then
        { model | selectedUrl = msg.data }

    else
        model


photoListUrl : String
photoListUrl =
    "http:/elm-in-action.com/list-photos"


urlPrefix =
    "http://elm-in-action.com/"


view model =
    div [ class "content" ]
        [ h1 [] [ text "Photo Groove" ]
        , div [ id "thumbnails" ]
            (List.map (viewThumbnail model.selectedUrl) model.photos)
        , img [ class "large", src (urlPrefix ++ "large/" ++ model.selectedUrl) ] []
        ]


viewThumbnail selectedUrl thumb =
    img
        [ src (urlPrefix ++ thumb.url)
        , classList [ ( "selected", selectedUrl == thumb.url ) ]
        , onClick { description = "Clicked photo", data = thumb.url }
        ]
        []


photoArray : Array { url : String }
photoArray =
    Array.fromList initialModel.photos


initialModel : { photos : List { url : String }, selectedUrl : String }
initialModel =
    { photos =
        [ { url = "1.jpeg" }
        , { url = "2.jpeg" }
        , { url = "3.jpeg" }
        ]
    , selectedUrl = "1.jpeg"
    }


main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
