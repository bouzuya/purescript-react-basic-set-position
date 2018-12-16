module Component.App
  ( app
  ) where

import Prelude

import Data.Maybe (Maybe(..), fromMaybe, maybe)
import React.Basic (Component, JSX, ReactComponent, Self, StateUpdate(..), createComponent, element, make)
import React.Basic.DOM as H

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

component :: Component Props
component = createComponent "App"

app :: JSX
app = make component { initialState, render, update } {}

initialState :: State
initialState =
  { lat: "35"
  , lng: "135"
  , position: Nothing
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
                  { url: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
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
            { value: self.state.lat
            }
          ]
        , H.label_
          [ H.span_ [ H.text "longitude" ]
          , H.input
            { value: self.state.lng
            }
          ]
        , H.button
          { children: [ H.text "OK" ]
          }
        ]
      }
    , H.div
      { className: "footer" }
    ]
  }

update :: Self Props State Action -> Action -> StateUpdate Props State Action
update self Noop = NoUpdate
