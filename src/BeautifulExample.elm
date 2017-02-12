module BeautifulExample exposing (view)

{-|

@docs view

-}

import Html exposing (..)
import Html.Attributes exposing (style)
import Color exposing (Color)
import Color.Convert


type alias Config =
    { title : String
    , details : Maybe String
    , color : Maybe Color
    , maxWidth : Int
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
            [ style
                [ ( "max-width"
                  , config.maxWidth
                        |> (toString >> flip (++) "px")
                  )
                , ( "margin", "auto" )
                , ( "padding", "16px" )
                ]
            ]
            [ h1
                [ style
                    [ ( "font-family", "sans-serif" )
                    , ( "font-weight", "200" )
                    , ( "color"
                      , Color.Convert.colorToCssRgb headingColor
                      )
                    ]
                ]
                [ text config.title ]
            , p
                [ style
                    [ ( "font-family", "sans-serif" )
                    , ( "font-weight", "200" )
                    , ( "font-style", "italic" )
                    , ( "line-height", "1.5em" )
                    , ( "color", Color.Convert.colorToCssRgb detailsColor )
                    ]
                ]
                [ text (config.details |> Maybe.withDefault "") ]
            , div
                [ style
                    [ ( "padding", "16px" )
                    , ( "background-color", Color.Convert.colorToCssRgb backgroundColor )
                    , ( "border-radius", "6px" )
                    ]
                ]
                [ content ]
            ]
