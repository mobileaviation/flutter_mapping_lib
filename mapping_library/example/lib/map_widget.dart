import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mapping_library/mapping_library.dart';
import 'package:mapping_library_extentions/extentions.dart';
import 'package:geometric_utils/geometric_utils.dart';

import 'test_vectors.dart';

class MapWidget extends StatelessWidget {
  MapWidget() {
    mapView = _retrieveMapContainer();
  }

  Widget mapView;

  @override
  Widget build(BuildContext context) {
    return _retrieveMapContainer();
  }

  Widget _retrieveMapContainer() {
    return Mapview(
        mapPosition: MapPosition.create(
          // This is a location in the middle of the netherlands
          geoPoint: new GeoPoint(52.45657243868931, 5.52041338863477),
          zoomLevel: 10,
        ),
        layers: Layers(
          layers: <Layer>[
//                TilesLayer(
//                  tileSource: HttpTileSource("http://tile.openstreetmap.nl/osm/##Z##/##X##/##Y##.png"),
//                  name: "Tiles Layer",
//                ),
            MultiTilesLayer(
              tileSources: <TileSource>[
                CachedHttpTileSource("https://snapshots.openflightmaps.org/live/2009/tiles/world/epsg3857/base/512/latest/##Z##/##X##/##Y##.jpg", "OpenFlightMapsBase1"),
                CachedHttpTileSource("https://snapshots.openflightmaps.org/live/2009/tiles/world/epsg3857/aero/512/latest/##Z##/##X##/##Y##.png","OpenFlightMapsAero1"),
                ],
              name: "Multitile Layer",
            ),
            // OverlayLayer(
            //   overlayImages: getOverlayImages(OverlayImages()),
            //   name: "Overlay Layer",
            // ),
            // FixedObjectLayer(
            //   fixedObject: ScaleBar(FixedObjectPosition.lefttop,
            //       Offset(10,10)),
            //   name: "FixedObject Layer",
            // ),
            // MarkersLayer(
            //   markers: getMarkers(Markers()),
            //   name: "Markers Layer",
            //   markerSelected: _markerSelected,
            // ),
            VectorLayer(
              vectors: getVectors(Vectors()),
              name: "Vectors Layer",
              vectorSelected: _vectorSelected,
              pointDragStart: _dragVectorStart,
              pointDragEnd: _dragVectorEnd,
            )
          ],
        ),
      );
  }

  void _vectorSelected(GeomBase vector, GeoPoint clickedPosition, Offset screenPos) {
    log("Vector selected: ${vector.name}");
    if (vector is Polyline) log("Polyline Part selected index: ${(vector as Polyline).selectedIndex}");
    // setState(() {
    //   editWindowVisible = true;
    //   editWindowPosition = screenPos;
    // });
    if (vectorSelected != null) vectorSelected(vector, clickedPosition, screenPos);
  }

  Function (GeomBase vector, GeoPoint clickedPosition, Offset screenPos) vectorSelected;

  void _markerSelected(MarkerBase marker){
    log("Marker selected: ${marker.name}");
  }

  _dragVectorStart(GeomBase vector, MarkerGeopoint marker_point, GeoPoint startPosition, Offset screenPos) {
    log("Start Drag Vector: ${vector.name} at ${startPosition.toString()}");
  }

  _dragVectorEnd(GeomBase vector, MarkerGeopoint marker_point, GeoPoint endPosition, Offset screenPos) {
    log("End Drag Vector: ${vector.name} at ${endPosition.toString()}");
  }
}