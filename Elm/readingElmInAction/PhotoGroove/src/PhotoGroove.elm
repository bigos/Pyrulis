module PhotoGroove exposing (main)

import Array exposing (Array)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type alias Model =
    { photos : List Photo
    , selectedUrl : String
    , chosenSize : Thumbnailsize
    }


type Thumbnailsize
    = Small
    | Medium
    | Large


type alias Photo =
    { url : String }


type Msg
    = ClickedPhoto String
    | ClickedSize Thumbnailsize
    | ClickedSurpriseMe


getPhotoUrl : Int -> String
getPhotoUrl index =
    case Array.get index photoArray of
        Just photo ->
            photo.url

        Nothing ->
            ""


update : Msg -> Model -> Model
update msg model =
    case msg of
        ClickedPhoto url ->
            { model | selectedUrl = url }

        ClickedSurpriseMe ->
            { model | selectedUrl = "2.jpeg" }

        ClickedSize size ->
            { model | chosenSize = size }


photoListUrl : String
photoListUrl =
    "http:/elm-in-action.com/list-photos"


urlPrefix =
    "http://elm-in-action.com/"


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ p [] [ text <| Debug.toString model ]
        , h1 [] [ text "Photo Groove" ]
        , button
            [ onClick ClickedSurpriseMe ]
            [ text "Surprise Me!" ]
        , h3 [] [ text "Thumbnail Size:" ]
        , div [ id "choose-size" ]
            (List.map viewSizeChooser [ Small, Medium, Large ])
        , div [ id "thumbnails", class (sizeToString model.chosenSize) ]
            (List.map (viewThumbnail model.selectedUrl) model.photos)
        , img [ class "large", src (urlPrefix ++ "large/" ++ model.selectedUrl) ] []
        ]


viewSizeChooser : Thumbnailsize -> Html Msg
viewSizeChooser size =
    label
        []
        [ input [ type_ "radio", name "size", onClick (ClickedSize size) ] []
        , text (sizeToString size)
        ]


sizeToString : Thumbnailsize -> String
sizeToString size =
    case size of
        Small ->
            "small"

        Medium ->
            "medium"

        Large ->
            "large"


viewThumbnail : String -> Photo -> Html Msg
viewThumbnail selectedUrl thumb =
    img
        [ src (urlPrefix ++ thumb.url)
        , classList [ ( "selected", selectedUrl == thumb.url ) ]
        , onClick (ClickedPhoto thumb.url)
        ]
        []


photoArray : Array Photo
photoArray =
    Array.fromList initialModel.photos


initialModel : Model
initialModel =
    { photos =
        [ { url = "1.jpeg" }
        , { url = "2.jpeg" }
        , { url = "3.jpeg" }
        ]
    , selectedUrl = "1.jpeg"
    , chosenSize = Small
    }


main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
