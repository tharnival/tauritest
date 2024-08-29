port module Main exposing (..)

import Browser
import Css
import Html exposing (Html)
import Html.Styled exposing (button, div, text, br, main_, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Tailwind.Theme exposing (..)
import Tailwind.Utilities exposing (..)


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
  let
      buttonStyle =
        css
          [ bg_color gray_300
          , border_0
          , rounded_md
          , text_2xl
          -- , w_32
          , py_2
          , Css.hover [ bg_color gray_600 ]
          , Css.active [ bg_color gray_800 ]
          ]
  in
  toUnstyled <| main_ [] [
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model.count) ]
    , button [ buttonStyle, onClick Increment ] [ text "+" ]
    , br [] []
    , button [ buttonStyle, onClick Reset ] [ text "reset" ]
    ]
  ]
