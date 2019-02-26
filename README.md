[![Build Status](https://travis-ci.org/avh4/elm-beautiful-example.svg?branch=master)](https://travis-ci.org/avh4/elm-beautiful-example)
[![Latest Version](https://img.shields.io/elm-package/v/avh4/elm-beautiful-example.svg?label=version)](https://package.elm-lang.org/packages/avh4/elm-beautiful-example/latest/)

# elm-beautiful-example

This package makes it easy to create beautiful examples for your Elm projects
and packages.

![Screenshot of a Counter example using elm-beautiful-example](https://github.com/avh4/elm-beautiful-example/raw/master/screenshot.png)


## Usage

Start with your not-so-pretty Elm example:

![Screenshot of the original, not-so-pretty Counter example from the Elm Guide](https://github.com/avh4/elm-beautiful-example/raw/master/before.png)

1. Install elm-beautiful-example

   ```sh
   elm-package install avh4/elm-beautiful-example
   ```

2. Replace `Html.program` or `Html.beginnerProgram`
with `BeautifulExample.program` or `BeautifulExample.beginnerProgram`
and add the beautiful example config,
filling in the fields as appropriate for your example:

   ```diff
   +import BeautifulExample

    main : Program Never Model Msg
    main =
   -    Html.program
   +    BeautifulExample.program
   +        { title = "Counter"
   +        , details =
   +            Just """This shows how elm-beautiful-example can be used to
   +              wrap the view of any other program (in this case, the Counter example
   +              from the Elm Guide)."""
   +        , color = Just Color.blue
   +        , maxWidth = 400
   +        , githubUrl = Just "https://github.com/avh4/elm-beautiful-example"
   +        , documentationUrl = Just "http://package.elm-lang.org/packages/avh4/elm-beautiful-example/latest"
   +        }
            { init = ( model, Cmd.none )
            , update = update
            , subscriptions = \_ -> Sub.none
            , view = view
            }
   ```

Now your example will look like this:

![Screenshot of a Counter example using elm-beautiful-example](https://github.com/avh4/elm-beautiful-example/raw/master/screenshot.png)
