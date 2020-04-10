module BeautifulExample exposing (Config, sandbox, element, document, application, view)

{-| Create beautiful examples to show off your Elm packages and projects.

@docs Config, sandbox, element, document, application, view

-}

import Browser
import Browser.Navigation
import Color exposing (Color)
import Html exposing (..)
import Html.Attributes exposing (class, href, style)
import Svg exposing (Svg)
import Svg.Attributes
import Url exposing (Url)


{-| Configuration for `BeautifulExample.view`

  - title: The title of the example
  - details: An optional explanatory paragraph about the example
  - color: The the color to use to theme the example (grey will be used if you give `Nothing`)
  - maxWidth: The maximum width of the container for the example
    (This allows the example to be nicely centered.)
  - githubUrl: If given, show a github icon with a link to this URL
  - documentationUrl: If given, show an Elm icon with a link to this URL

-}
type alias Config =
    { title : String
    , details : Maybe String
    , color : Maybe Color
    , maxWidth : Int
    , githubUrl : Maybe String
    , documentationUrl : Maybe String
    }


{-| Turn a `Browser.sandbox` into a beautiful example
-}
sandbox :
    Config
    ->
        { init : model
        , view : model -> Html msg
        , update : msg -> model -> model
        }
    -> Program () model msg
sandbox config prog =
    Browser.sandbox
        { init = prog.init
        , update = prog.update
        , view =
            prog.view
                >> view config
        }


{-| Turn a `Browser.element` into a beautiful example
-}
element :
    Config
    ->
        { init : flags -> ( model, Cmd msg )
        , view : model -> Html msg
        , update : msg -> model -> ( model, Cmd msg )
        , subscriptions : model -> Sub msg
        }
    -> Program flags model msg
element config prog =
    Browser.element
        { init = prog.init
        , update = prog.update
        , subscriptions = prog.subscriptions
        , view =
            prog.view
                >> view config
        }


{-| Turn a `Browser.document` into a beautiful example
-}
document :
    Config
    ->
        { init : flags -> ( model, Cmd msg )
        , view : model -> Browser.Document msg
        , update : msg -> model -> ( model, Cmd msg )
        , subscriptions : model -> Sub msg
        }
    -> Program flags model msg
document config prog =
    Browser.document
        { init = prog.init
        , update = prog.update
        , subscriptions = prog.subscriptions
        , view = prog.view >> wrapDocument config
        }


wrapDocument : Config -> Browser.Document msg -> Browser.Document msg
wrapDocument config doc =
    { doc
        | body =
            [ view config <|
                Html.div [] doc.body
            ]
    }


{-| Turn a `Browser.application` into a beautiful example
-}
application :
    Config
    ->
        { init : flags -> Url -> Browser.Navigation.Key -> ( model, Cmd msg )
        , view : model -> Browser.Document msg
        , update : msg -> model -> ( model, Cmd msg )
        , subscriptions : model -> Sub msg
        , onUrlRequest : Browser.UrlRequest -> msg
        , onUrlChange : Url -> msg
        }
    -> Program flags model msg
application config prog =
    Browser.application
        { init = prog.init
        , update = prog.update
        , subscriptions = prog.subscriptions
        , onUrlRequest = prog.onUrlRequest
        , onUrlChange = prog.onUrlChange
        , view = prog.view >> wrapDocument config
        }


{-| Turn arbitrary Html into a beautiful example.

Typically, you will want to use [`program`](#program) or [`beginnerProgram`](#beginnerProgram) instead.

-}
view : Config -> Html msg -> Html msg
view config content =
    let
        { hue, saturation, lightness } =
            config.color
                |> Maybe.withDefault Color.gray
                |> Color.toHsla

        detailsColor =
            Color.hsl hue (saturation * 0.8) (lightness * 0.5 + 0.28)
    in
    div
        [ class [ Page ] ]
        [ stylesTag
        , customizableStylesTag config.maxWidth config.color
        , h1 [ class [ PageHeader ] ] <|
            List.concat
                [ [ text config.title ]
                , case config.documentationUrl of
                    Nothing ->
                        []

                    Just url ->
                        [ Html.text " "
                        , headerLink detailsColor elmLogo "Documentation" url
                        ]
                , case config.githubUrl of
                    Nothing ->
                        []

                    Just url ->
                        [ Html.text " "
                        , headerLink detailsColor githubIcon "Source" url
                        ]
                ]
        , p
            [ class [ PageDescription ] ]
            [ text (config.details |> Maybe.withDefault "") ]
        , div
            [ class [ Example ] ]
            [ content ]
        ]


headerLink : Color -> (Color -> Html msg) -> String -> String -> Html msg
headerLink color icon title url =
    a
        [ href url
        , class [ PageHeaderLink ]
        ]
        [ icon color
        , Html.text " "
        , Html.span
            [ class [ PageHeaderLinkText ] ]
            [ Html.text title ]
        ]


githubIcon : Color -> Html msg
githubIcon color =
    Svg.svg
        [ Html.Attributes.attribute "aria-hidden" "true"
        , Svg.Attributes.version "1.1"
        , Svg.Attributes.viewBox "0 0 16 16"
        , style "height" "0.8em"
        ]
        [ Svg.path
            [ Svg.Attributes.d "M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0 0 16 8c0-4.42-3.58-8-8-8z"
            , Svg.Attributes.fill <| Color.toCssString color
            , Html.Attributes.attribute "fill-rule" "evenodd"
            ]
            []
        ]


elmLogo : Color -> Html msg
elmLogo color =
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.viewBox "0 0 323.141 322.95"
        , style "height" "0.8em"
        ]
        [ Svg.polygon
            [ Svg.Attributes.fill <| Color.toCssString color
            , Svg.Attributes.points "161.649,152.782 231.514,82.916 91.783,82.916"
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.fill <| Color.toCssString color
            , Svg.Attributes.points "8.867,0 79.241,70.375 232.213,70.375 161.838,0"
            ]
            []
        , Svg.rect
            [ Svg.Attributes.fill <| Color.toCssString color
            , Svg.Attributes.x "192.99"
            , Svg.Attributes.y "107.392"
            , Svg.Attributes.width "107.676"
            , Svg.Attributes.height "108.167"
            , Svg.Attributes.transform "matrix(0.7071 0.7071 -0.7071 0.7071 186.4727 -127.2386)"
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.fill <| Color.toCssString color
            , Svg.Attributes.points "323.298,143.724 323.298,0 179.573,0"
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.fill <| Color.toCssString color
            , Svg.Attributes.points "152.781,161.649 0,8.868 0,314.432"
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.fill <| Color.toCssString color
            , Svg.Attributes.points "255.522,246.655 323.298,314.432 323.298,178.879"
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.fill <| Color.toCssString color
            , Svg.Attributes.points "161.649,170.517 8.869,323.298 314.43,323.298"
            ]
            []
        ]


type CssClasses
    = Page
    | PageHeader
    | PageHeaderLink
    | PageHeaderLinkText
    | PageDescription
    | Example


class : List CssClasses -> Html.Attribute msg
class classes =
    let
        toString cl =
            case cl of
                Page ->
                    "Page"

                PageHeader ->
                    "PageHeader"

                PageHeaderLink ->
                    "PageHeaderLink"

                PageHeaderLinkText ->
                    "PageHeaderLinkText"

                PageDescription ->
                    "PageDescription"

                Example ->
                    "Example"
    in
    classes
        |> List.map toString
        -- TODO
        |> List.map ((++) "avh4--elm-beautiful-example--")
        |> String.join " "
        |> Html.Attributes.class


customizableStylesTag : Int -> Maybe Color -> Html msg
customizableStylesTag maxWidth themeColor =
    let
        baseColor =
            themeColor
                |> Maybe.withDefault Color.gray

        { hue, saturation, lightness } =
            baseColor
                |> Color.toHsla

        headingColor =
            Color.hsl hue saturation (lightness * 0.7)

        detailsColor =
            Color.hsl hue (saturation * 0.8) (lightness * 0.5 + 0.28)

        backgroundColor =
            Color.hsl hue (saturation * 1.2) (lightness * 0.05 + 0.93)
    in
    Html.node "style"
        []
        [ Html.text <|
            String.join "\n"
                [ ".avh4--elm-beautiful-example--Page {"
                , "  max-width: " ++ String.fromInt maxWidth ++ "px;"
                , "}"
                , ".avh4--elm-beautiful-example--PageHeader {"
                , "  color: " ++ Color.toCssString headingColor ++ ";"
                , "}"
                , ".avh4--elm-beautiful-example--PageHeaderLink {"
                , "  color: " ++ Color.toCssString detailsColor ++ ";"
                , "}"
                , ".avh4--elm-beautiful-example--PageHeaderLink:hover {"
                , "  background-color: " ++ Color.toCssString backgroundColor ++ ";"
                , "}"
                , ".avh4--elm-beautiful-example--PageDescription {"
                , "  color: " ++ Color.toCssString detailsColor ++ ";"
                , "}"
                , ".avh4--elm-beautiful-example--Example {"
                , "  background-color: " ++ Color.toCssString backgroundColor ++ ";"
                , "  color: " ++ Color.toCssString headingColor ++ ";"
                , "}"
                , ".avh4--elm-beautiful-example--Example button {"
                , "  background-color: " ++ Color.toCssString baseColor ++ ";"
                , "  color: #fff;"
                , "}"
                , ".avh4--elm-beautiful-example--Example button:hover {"
                , "  background-color: " ++ Color.toCssString detailsColor ++ ";"
                , "}"
                , ".avh4--elm-beautiful-example--Example button:active {"
                , "  background-color: " ++ Color.toCssString backgroundColor ++ ";"
                , "}"
                , ".avh4--elm-beautiful-example--Example input {"
                , "  color: " ++ Color.toCssString baseColor ++ ";"
                , "  border-color: " ++ Color.toCssString baseColor ++ ";"

                -- , Css.property "::-webkit-input-placeholder" (elmColor detailsColor)
                -- , Css.property ":-ms-input-placeholder" (elmColor detailsColor)
                -- , Css.property "::-moz-placeholder" (elmColor detailsColor)
                -- , Css.property ":-moz-placeholder" (elmColor detailsColor)
                , "}"
                , ".avh4--elm-beautiful-example--Example textarea {"
                , "  color: " ++ Color.toCssString baseColor ++ ";"
                , "  border-color: " ++ Color.toCssString baseColor ++ ";"
                , "}"
                ]
        ]


stylesTag : Html msg
stylesTag =
    Html.node "style"
        []
        [ Html.text """
.avh4--elm-beautiful-example--Page {
  margin: auto;
  padding: 48px 0;
  font-family: sans-serif;
}
.avh4--elm-beautiful-example--PageHeader {
  font-weight: 200;
  font-size: 32px;
  line-height: 37px;
  margin-top: 0;
}
.avh4--elm-beautiful-example--PageHeaderLink {
  padding: 3px 8px 1px;
  text-decoration: none;
  vertical-align: bottom;
  border-radius: 4px;
}
.avh4--elm-beautiful-example--PageHeaderLink:hover .avh4--elm-beautiful-example--PageHeaderLinkText {
  text-decoration: underline;
}
.avh4--elm-beautiful-example--PageHeaderLinkText {
  font-size: 12px;
  line-height: 37px;
  vertical-align: bottom;
}
.avh4--elm-beautiful-example--PageDescription {
  font-weight: 200;
  font-style: italic;
  line-height: 1.5em;
}
.avh4--elm-beautiful-example--Example {
  padding: 16px;
  border-radius: 6px;
  line-height: 1.5em;
}
.avh4--elm-beautiful-example--Example > *:first-child {
  margin-top: 0;
}
.avh4--elm-beautiful-example--Example > *:last-child {
  margin-bottom: 0;
}
.avh4--elm-beautiful-example--Example > * > *:first-child {
  margin-top: 0;
}
.avh4--elm-beautiful-example--Example > * > *:last-child {
  margin-bottom: 0;
}
.avh4--elm-beautiful-example--Example button {
  cursor: pointer;
  border-style: none;
  border-radius: 2px;
  height: 28px;
  line-height: 28px;
  padding: 0 16px;
  text-transform: uppercase;
  font-size: 14px;
  letter-spacing: 0.5px;
  text-align: center;
  text-decoration: none;
  transition: 0.3s ease-out;
  box-shadow: 0 2px 2px 0 rgba(0,0,0,0.14), 0 1px 5px 0 rgba(0,0,0,0.12), 0 3px 1px -2px rgba(0,0,0,0.2);
  margin: 4px 0;
}
.avh4--elm-beautiful-example--Example button:hover {
  box-shadow: 0 3px 3px 0 rgba(0,0,0,0.14), 0 1px 7px 0 rgba(0,0,0,0.12), 0 3px 1px -1px rgba(0,0,0,0.2);
}
.avh4--elm-beautiful-example--Example input {
  padding: 4px;
  border-radius: 4px;
  border: 2px solid;
  margin: 4px 0;
  font-size: 16px;
  box-sizing: border-box;
}
.avh4--elm-beautiful-example--Example textarea {
  padding: 4px;
  border-radius: 4px;
  border: 2px solid;
  margin: 4px 0;
  font-size: 16px;
  display: block;
  box-sizing: border-box;
  width: 100%;
}
.avh4--elm-beautiful-example--Example pre {
  line-height: 14px;
  font-size: 12px;
}
""" ]
