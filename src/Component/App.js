"use strict";

var react = require('react');
var leaflet = require('react-leaflet');

exports.leafletMap = leaflet.Map;
exports.leafletMarker = leaflet.Marker;
exports.leafletTileLayer = leaflet.TileLayer;

exports.myMarker = function (props) {
  var ref = react.createRef();
  return react.createElement(
    leaflet.Marker,
    Object.assign({}, props, {
      onDragEnd: function () {
        var e = ref.current;
        if (e !== null) {
          var latLng = e.leafletElement.getLatLng();
          props.onDragEnd(latLng);
        }
      },
      ref: ref
    }),
    []
  );
}
