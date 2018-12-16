module Component.App
  ( app
  ) where

import Data.Maybe (Maybe(..), fromMaybe)
import Data.Number as Number
import Prelude ((<$>), (<*>), (<>))
import React.Basic (Component, JSX, ReactComponent, Self, StateUpdate(..), capture, capture_, createComponent, element, make)
import React.Basic.DOM as H
import React.Basic.DOM.Events (targetValue)

foreign import leafletMap :: forall props. ReactComponent { | props }
foreign import leafletMarker :: forall props. ReactComponent { | props }
foreign import leafletTileLayer :: forall props. ReactComponent { | props }

type Props =
  {}

type State =
  { lat :: String
  , lng :: String
  , position :: Maybe (Array Number)
  }

data Action
  = Noop
  | ChangeLat String
  | ChangeLng String
  | OK

component :: Component Props
component = createComponent "App"

app :: JSX
app = make component { initialState, render, update } {}

fromString :: String -> String -> Maybe (Array Number)
fromString latS lngS =
  (\lat lng -> [lat, lng]) <$> Number.fromString latS <*> Number.fromString lngS

initialState :: State
initialState =
  let
    lat = "35.0"
    lng = "135.0"
  in
    { lat
    , lng
    , position: fromString lat lng
    }

render :: Self Props State Action -> JSX
render self =
  H.div
  { className: "app"
  , children:
    [ H.div
      { className: "header"
      , children:
        [ H.h1_
          [ H.text "App" ]
        ]
      }
    , H.div
      { className: "body"
      , children:
        [ element
            leafletMap
            { center: fromMaybe [35.0, 135.0] self.state.position
            , zoom: 10
            , children:
              [ element
                  leafletTileLayer
                  { attribution: "&copy; <a href=\"http://osm.org/copyright\">OpenStreetMap</a> contributors"
                  , url: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                  }
              ] <>
                case self.state.position of
                  Nothing -> []
                  Just position ->
                    [ element leafletMarker { position }
                    ]
            }
        , H.label_
          [ H.span_ [ H.text "latitude" ]
          , H.input
            { onChange:
                capture
                  self
                  targetValue
                  (\value -> ChangeLat (fromMaybe "" value))
            , step: "0.1"
            , "type": "number"
            , value: self.state.lat
            }
          ]
        , H.label_
          [ H.span_ [ H.text "longitude" ]
          , H.input
            { onChange:
                capture
                  self
                  targetValue
                  (\value -> ChangeLng (fromMaybe "" value))
            , step: "0.1"
            , "type": "number"
            , value: self.state.lng
            }
          ]
        , H.button
          { onClick: capture_ self OK
          , children: [ H.text "OK" ]
          }
        ]
      }
    , H.div
      { className: "footer" }
    ]
  }

update :: Self Props State Action -> Action -> StateUpdate Props State Action
update self Noop = NoUpdate
update self@{ state: { lng } } (ChangeLat v) =
  Update self.state { lat = v, position = fromString v lng }
update self@{ state: { lat } } (ChangeLng v) =
  Update self.state { lng = v, position = fromString lat v }
update self OK =
  Update self.state { position = fromString self.state.lat self.state.lng }
