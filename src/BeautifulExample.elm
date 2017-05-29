module BeautifulExample exposing (Config, view)

{-| Create beautiful examples to show off your Elm packages and projects.

@docs Config, view

-}

import Color exposing (Color)
import Color.Convert
import Css
import Html exposing (..)
import Html.Attributes exposing (href, style)
import Html.CssHelpers
import Svg exposing (Svg)
import Svg.Attributes


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


{-| Turn arbitrary Html into a beautiful example
-}
view : Config -> Html msg -> Html msg
view config content =
    let
        { hue, saturation, lightness } =
            config.color
                |> Maybe.withDefault Color.gray
                |> Color.toHsl

        headingColor =
            Color.hsl hue saturation (lightness * 0.7)

        detailsColor =
            Color.hsl hue (saturation * 0.8) (lightness * 0.5 + 0.3)

        backgroundColor =
            Color.hsl hue (saturation * 1.2) (lightness * 0.05 + 0.93)
    in
    div
        [ class [ Page ]
        , style
            [ ( "max-width"
              , config.maxWidth
                    |> (toString >> flip (++) "px")
              )
            ]
        ]
        [ stylesTag
        , h1
            [ class [ PageHeader ]
            , style
                [ ( "color", Color.Convert.colorToCssRgb headingColor )
                ]
            ]
          <|
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
            [ class [ PageDescription ]
            , style
                [ ( "color", Color.Convert.colorToCssRgb detailsColor )
                ]
            ]
            [ text (config.details |> Maybe.withDefault "") ]
        , div
            [ class [ Example ]
            , style
                [ ( "background-color", Color.Convert.colorToCssRgb backgroundColor )
                , ( "color", Color.Convert.colorToCssRgb headingColor )
                ]
            ]
            [ content ]
        ]


headerLink : Color -> (Color -> Html msg) -> String -> String -> Html msg
headerLink color icon title url =
    a
        [ href url
        , class [ PageHeaderLink ]
        , style
            [ ( "color", Color.Convert.colorToCssRgb color )
            ]
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
        , style [ ( "height", "0.8em" ) ]
        ]
        [ Svg.path
            [ Svg.Attributes.d "M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0 0 16 8c0-4.42-3.58-8-8-8z"
            , Svg.Attributes.fill <| Color.Convert.colorToCssRgb color
            , Html.Attributes.attribute "fill-rule" "evenodd"
            ]
            []
        ]


elmLogo : Color -> Html msg
elmLogo color =
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.viewBox "0 0 323.141 322.95"
        , style [ ( "height", "0.8em" ) ]
        ]
        [ Svg.polygon
            [ Svg.Attributes.fill <| Color.Convert.colorToCssRgb color
            , Svg.Attributes.points "161.649,152.782 231.514,82.916 91.783,82.916"
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.fill <| Color.Convert.colorToCssRgb color
            , Svg.Attributes.points "8.867,0 79.241,70.375 232.213,70.375 161.838,0"
            ]
            []
        , Svg.rect
            [ Svg.Attributes.fill <| Color.Convert.colorToCssRgb color
            , Svg.Attributes.x "192.99"
            , Svg.Attributes.y "107.392"
            , Svg.Attributes.width "107.676"
            , Svg.Attributes.height "108.167"
            , Svg.Attributes.transform "matrix(0.7071 0.7071 -0.7071 0.7071 186.4727 -127.2386)"
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.fill <| Color.Convert.colorToCssRgb color
            , Svg.Attributes.points "323.298,143.724 323.298,0 179.573,0"
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.fill <| Color.Convert.colorToCssRgb color
            , Svg.Attributes.points "152.781,161.649 0,8.868 0,314.432"
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.fill <| Color.Convert.colorToCssRgb color
            , Svg.Attributes.points "255.522,246.655 323.298,314.432 323.298,178.879"
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.fill <| Color.Convert.colorToCssRgb color
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


{ class } =
    Html.CssHelpers.withNamespace ""


stylesTag : Html msg
stylesTag =
    [ Css.stylesheet
        [ Css.class Page
            [ Css.margin Css.auto
            , Css.padding2 (Css.px 48) Css.zero
            , Css.fontFamily Css.sansSerif
            ]
        , Css.class PageHeader
            [ Css.fontWeight (Css.int 200)
            , Css.fontSize (Css.px 32)
            , Css.lineHeight (Css.px 37)
            , Css.marginTop Css.zero
            ]
        , Css.class PageHeaderLink
            [ Css.padding2 (Css.px 2) (Css.px 8)
            , Css.textDecoration Css.none
            , Css.verticalAlign Css.bottom
            , Css.borderRadius (Css.px 4)
            , Css.hover
                [ Css.backgroundColor (Css.hex "#ddd")
                , Css.descendants
                    [ Css.class PageHeaderLinkText
                        [ Css.textDecoration Css.underline
                        ]
                    ]
                ]
            ]
        , Css.class PageHeaderLinkText
            [ Css.fontSize (Css.px 12)
            , Css.lineHeight (Css.px 37)
            , Css.verticalAlign Css.bottom
            ]
        , Css.class PageDescription
            [ Css.fontWeight (Css.int 200)
            , Css.fontStyle Css.italic
            , Css.lineHeight (Css.em 1.5)
            ]
        , Css.class Example
            [ Css.padding (Css.px 16)
            , Css.borderRadius (Css.px 6)
            , Css.lineHeight (Css.em 1.5)
            , Css.children
                [ Css.everything
                    [ Css.firstChild [ Css.marginTop Css.zero ]
                    , Css.lastChild [ Css.marginBottom Css.zero ]
                    , Css.children
                        [ Css.everything
                            [ Css.firstChild [ Css.marginTop Css.zero ]
                            , Css.lastChild [ Css.marginBottom Css.zero ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]
        |> Css.compile
        |> .css
        |> Html.CssHelpers.style
