port module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text, br)
import Html.Events exposing (onClick)


-- MAIN

main =
  Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }


-- MODEL

type alias Model =
  { count : Int }

init : () -> (Model, Cmd msg)
init flags =
  ({ count = 0 }, Cmd.none)


-- PORT

port increment : Int -> Cmd msg
port decrement : Int -> Cmd msg
port updateCount : (Int -> msg) -> Sub msg


-- UPDATE

type Msg
  = UpdateCount Int
  | Increment
  | Decrement
  | Reset


update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    UpdateCount newCount ->
      ({model | count = newCount}, Cmd.none)
    Increment ->
      (model, increment(model.count))
    Decrement ->
      (model, decrement(model.count))
    Reset ->
      ({model | count = 0}, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  updateCount UpdateCount


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model.count) ]
    , button [ onClick Increment ] [ text "+" ]
    , br [] []
    , button [ onClick Reset ] [ text "reset" ]
    ]
