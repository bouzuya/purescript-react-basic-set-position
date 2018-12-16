module Component.App
  ( app
  ) where

import React.Basic (Component, JSX, ReactComponent, Self, StateUpdate(..), createComponent, element, make)
import React.Basic.DOM as H

foreign import leafletMap :: forall props. ReactComponent { | props }
foreign import leafletMarker :: forall props. ReactComponent { | props }
foreign import leafletTileLayer :: forall props. ReactComponent { | props }

type Props =
  {}

type State =
  {}

data Action
  = Noop

component :: Component Props
component = createComponent "App"

app :: JSX
app = make component { initialState, render, update } {}

initialState :: State
initialState =
  {}

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
            { center: [35, 135]
            , zoom: 10
            , children:
              [ element
                  leafletTileLayer
                  { url: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                  }
              , element
                  leafletMarker
                  { position: [35, 135]
                  }
              ]
            }
        , H.label_
          [ H.span_ [ H.text "latitude" ]
          , H.input
            { value: "35"
            }
          ]
        , H.label_
          [ H.span_ [ H.text "longitude" ]
          , H.input
            { value: "135"
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
