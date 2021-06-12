module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, map2, string)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Flags =
    { domain : String, countriesUrl : String }


type CatStatuses
    = Failure Http.Error
    | Loading
    | Success String


type alias RestCountry =
    { name : String, alpha2code : String }


type CountryStatuses
    = CountryStatusFailure Http.Error
    | CountryStatusLoading
    | CountryStatusSuccess (List RestCountry)


type alias Model =
    { catStatuses : CatStatuses
    , countryStatuses : CountryStatuses
    , countrySearchString : String
    , flags : Flags
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { flags = flags
      , catStatuses = Loading
      , countryStatuses = CountryStatusLoading
      , countrySearchString = ""
      }
    , getRandomCatGif
    )


searchLongEnough model =
    String.length model.countrySearchString >= 3



-- UPDATE


type Msg
    = MorePlease
    | GotGif (Result Http.Error String)
    | FindCountry
    | ChangeSearchString String
    | GotCountry (Result Http.Error (List RestCountry))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( { model | catStatuses = Loading }, getRandomCatGif )

        GotGif result ->
            case result of
                Ok url ->
                    ( { model | catStatuses = Success url }, Cmd.none )

                Err errstr ->
                    ( { model | catStatuses = Failure errstr }, Cmd.none )

        FindCountry ->
            ( { model | countryStatuses = CountryStatusLoading }, findCountry model )

        ChangeSearchString str ->
            ( { model | countrySearchString = str }
            , if searchLongEnough model then
                findCountry model

              else
                Cmd.none
            )

        GotCountry result ->
            case result of
                Ok dat ->
                    ( { model | countryStatuses = CountryStatusSuccess dat }, Cmd.none )

                Err errstr ->
                    ( { model | countryStatuses = CountryStatusFailure errstr }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Random Cats" ]
        , viewGif model
        , h3 [] [ text "Country search will go here" ]
        , p [] [ text (Debug.toString model) ]
        , viewCountrySearch model
        ]


viewCountrySearch model =
    case model.countryStatuses of
        CountryStatusFailure err ->
            text ("failure" ++ Debug.toString err)

        CountryStatusLoading ->
            div []
                [ p [] [ text "loading" ]
                , p []
                    [ input
                        [ placeholder "Search for aCountry"
                        , value model.countrySearchString
                        , onInput ChangeSearchString
                        ]
                        []
                    ]
                , if String.length model.countrySearchString < 3 then
                    p [] [ text "enter min 3 characters" ]

                  else
                    p [] [ button [ onClick FindCountry ] [ text "find countries" ] ]
                ]

        CountryStatusSuccess url ->
            div []
                [ p []
                    [ input
                        [ placeholder "Search for aCountry"
                        , value model.countrySearchString
                        , onInput ChangeSearchString
                        ]
                        []
                    ]
                , if String.length model.countrySearchString < 3 then
                    p [] [ text "enter min 3 characters" ]

                  else
                    p [] [ button [ onClick FindCountry ] [ text "find countries" ] ]
                , text ("success " ++ Debug.toString url)
                ]


viewGif : Model -> Html Msg
viewGif model =
    case model.catStatuses of
        Failure errstr ->
            div []
                [ text
                    ("I could not load a random cat because of " ++ Debug.toString errstr)
                , button [ onClick MorePlease ] [ text "Try Again!" ]
                ]

        Loading ->
            text "Loading..."

        Success url ->
            div []
                [ button [ onClick MorePlease, style "display" "block" ] [ text "More Please!" ]
                , img [ src url ] []
                ]



-- HTTP


getRandomCatGif : Cmd Msg
getRandomCatGif =
    Http.get
        { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
        , expect = Http.expectJson GotGif gifDecoder
        }


gifDecoder : Decoder String
gifDecoder =
    field "data" (field "image_url" string)


findCountry : Model -> Cmd Msg
findCountry model =
    let
        urls =
            model.flags.domain ++ model.flags.countriesUrl ++ model.countrySearchString
    in
    Http.get
        { url = urls
        , expect = Http.expectJson GotCountry restCountriesDecoder
        }


restCountryDecoder : Decoder RestCountry
restCountryDecoder =
    map2 RestCountry
        (field "name" string)
        (field "alpha2Code" string)


restCountriesDecoder : Decoder (List RestCountry)
restCountriesDecoder =
    Json.Decode.list restCountryDecoder
