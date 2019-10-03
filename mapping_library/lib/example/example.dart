import 'package:flutter/material.dart';
import 'package:mapping_library/utils/geopoint.dart';
import 'package:mapping_library/utils/mapposition.dart';
import 'package:mapping_library/core/mapview.dart' as mapview;
import 'package:mapping_library/Widgets/OsmMap.dart';

/// Very basic Flutter example using the mapping library

void main() => runApp(MyApp());

/// Simple Openstreetmap sample application
/// This will create an app with a fullscreen mapview widget showing
/// the openstreetmaps view
class MyApp extends StatelessWidget {
  /// Create the OsmMap object in the contructor of the app. This object needs to
  /// be persistent in memory during the livetime off the app
  MyApp() : super() {
    _osmMap = _createOsmMapWidget();
  }

  OsmMap _osmMap;

  /// Any processing, adding markers or changing the MapPosition of the Map only can
  /// take place after the initial call to mapReady. This will only be called once in
  /// the apps lifetime directly after startup..
  _mapReady(mapview.MapView mapView) {
  }

  /// Private function to setup the OsmMap widget
  /// The location used in this example is in the center of the Netherlands
  /// Also define a mapReady event if you want to do more processing on the
  /// MapView object like adding Marker or programmaticly changing the location
  /// (MapPosition) of the map.
  Widget _createOsmMapWidget() {
    return OsmMap(
        mapPosition: new MapPosition.Create(
          geoPoint: new GeoPoint(52.45657243868931, 5.52041338863477),
          zoomLevel: 11,
        ),
        mapReady: _mapReady,
    );
  }

  /// Build the apps interface. Add the created OsmMap Widget to a child of another
  /// widget like for instance a Container..
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Container(
          child: _osmMap,
        )
    );
  }
}

