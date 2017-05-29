module Counter exposing (main)

import BeautifulExample
import Color
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


main : Program Never Model Msg
main =
    BeautifulExample.program
        { title = "Counter"
        , details =
            Just """This shows how elm-beautiful-example can be used to
                  wrap the view of any other program (in this case, the Counter example
                  from the Elm Guide)."""
        , color = Just Color.blue
        , maxWidth = 400
        , githubUrl = Just "https://github.com/avh4/elm-beautiful-example"
        , documentationUrl = Just "http://package.elm-lang.org/packages/avh4/elm-beautiful-example/latest"
        }
        { init = ( model, Cmd.none )
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }



--
-- Everything below is copied directly from the Counter.elm example
-- in the Elm Guide.
--


type alias Model =
    { counter : Int
    }


model : Model
model =
    { counter = 1
    }


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | counter = model.counter + 1 }
            , Cmd.none
            )

        Decrement ->
            ( { model | counter = model.counter - 1 }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div []
        [ div [] [ button [ onClick Increment ] [ text "+" ] ]
        , div [] [ text <| toString model.counter ]
        , div [] [ button [ onClick Decrement ] [ text "-" ] ]
        ]
