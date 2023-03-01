module Main exposing (main)

import Browser exposing (Document)
import Html exposing (Html, a, footer, h1, li, nav, text, ul)
import Html.Attributes exposing (classList, href)
import Html.Lazy exposing (lazy)


type alias Model =
    { page : Page }


type Page
    = Gallery
    | Folders
    | NotFound


view : Model -> Document Msg
view model =
    let
        content =
            text "This isn't even my final form!"
    in
    { title = "Photo Groove, SPA Style"
    , body =
        [ lazy viewHeader model.page
        , content
        , viewFooter
        ]
    }


viewHeader : Page -> Html Msg
viewHeader page =
    let
        logo =
            h1 [] [ text "PhotoGroove" ]

        links =
            ul []
                [ navLink Folders { url = "/", caption = "Folders" }
                , navLink Gallery { url = "/gallery", caption = "Gallery" }
                ]

        navLink : Page -> { url : String, caption : String } -> Html msg
        navLink targetPage { url, caption } =
            li
                [ classList
                    [ ( "active"
                      , isActive
                            { link = url
                            , page = page
                            }
                      )
                    ]
                ]
                [ a [ href url ] [ text caption ] ]
    in
    nav [] [ logo, links ]



-- zzzzzzzzzzzzzzzzzz


isActive : { link : String, page : Page } -> Bool
isActive { link, page } =
    case ( link, page ) of
        ( _, _ ) ->
            True


viewFooter : Html msg
viewFooter =
    footer [] [ text "One is never alone with a rubber duck. -Douglas Adams" ]


type Msg
    = NothingYet


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program () Model Msg
main =
    Browser.application
        { init = \_ _ _ -> ( { page = Folders }, Cmd.none )
        , onUrlRequest = \_ -> Debug.todo "handle URL requests"
        , onUrlChange = \_ -> Debug.todo "handle URL changes"
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
