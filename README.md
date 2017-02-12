# elm-beautiful-example

This package makes it easy to create beautiful examples for your Elm projects
and packages.

![Screenshot of a Counter example using elm-beautiful-example](screenshot.png)


## Usage

Start with youre not-so-pretty Elm example:

![Screenshot of the original, not-so-pretty Counter example from the Elm Guide](before.png)

1. Install elm-beautiful-example

   ```sh
   elm-package install avh4/elm-beautiful-example
   ```

2. Add the following to your example's Main.elm
   and fill in the fields as appropriate to your example:

   ```elm
   beautifulView : Model -> Html Msg
   beautifulView model =
       view model
           |> BeautifulExample.view
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
   ```

3. Replace references to your original `view` function with the `beautifulView` that you just created:

   ```diff
    main : Program Never Model Msg
    main =
        Html.program
   -        { view = view
   +        { view = beautifulView
            , update = update
            , subscriptions = \_ -> Sub.none
            , init = ( model, Cmd.none )
            }
   ```

Now your example will look like this:

![Screenshot of a Counter example using elm-beautiful-example](screenshot.png)
