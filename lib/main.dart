import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mapping_library/layers/markerslayer.dart';
import 'package:mapping_library/layers/tilelayer.dart';
import 'package:mapping_library/layers/vectorlayer.dart';
import 'package:mapping_library/tiles/httptilesource.dart';
import 'package:mapping_library/utils/geopoint.dart';
import 'package:mapping_library/utils/geopoint.dart' as prefix0;
import 'package:mapping_library/utils/mapposition.dart';
import 'package:mapping_library/core/mapview.dart' as mapview;
import 'package:mapping_library/layers/Markers/simplemarker.dart';
import 'package:mapping_library/layers/Markers/defaultimagemarker.dart';
import 'package:mapping_library/layers/Markers/markerbase.dart';
import 'package:mapping_library/layers/Markers/Renderers/simplemarkerrenderer.dart';
import 'package:mapping_library/layers/Markers/Renderers/defaultmarkerrenderer.dart';
import 'package:mapping_library/layers/Markers/Renderers/defaultmarkers.dart';
import 'package:mapping_library/layers/Vector/line.dart';
import 'package:mapping_library/layers/Vector/circle.dart';
import 'package:mapping_library/Widgets/OsmMap.dart';
import 'package:mapping_library/utils/mapposition.dart' as prefix1;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp() : super() {
    _mapView = new mapview.MapView(_mapReady);
    _osmMap = _createOsmMapWidget();
  }

  mapview.MapView _mapView;
  OsmMap _osmMap;

  _mapReady(mapview.MapView mapView) {
//    GeoPoint s = new GeoPoint(52.45657243868931, 5.52041338863477);
//    GeoPoint t = new GeoPoint(52.383063, 5.556776);
//    GeoPoint e = new GeoPoint(52.349690, 5.634789);
//
//    final _url = "http://c.tile.openstreetmap.org/##Z##/##X##/##Y##.png";
//    HttpTileSource osmTileSource = new HttpTileSource(_url);
//    TileLayer tileLayer = new TileLayer(osmTileSource);
//    _mapView.AddLayer(tileLayer);

//    SimpleMarkerRenderer drawer = new SimpleMarkerRenderer();
//    SimpleMarker marker = new SimpleMarker(drawer, new Size(100,100), s);
//    marker.Name = "Marker1";
//    MarkersLayer makersLayer = new MarkersLayer();
//
//    makersLayer.MarkerSelected = (MarkerBase marker) {
//      log("Marker selected: " + marker.Name);
//    };
//
//    makersLayer.AddMarker(marker);
//
//    _mapView.AddLayer(makersLayer);
//
//    Line line = new Line(s, e);
//    Circle circle = new Circle(t, 1000);
//
//    VectorLayer vectorLayer = new VectorLayer();
//    vectorLayer.AddVectors(line);
//    vectorLayer.AddVectors(circle);
//    _mapView.AddLayer(vectorLayer);


//    MapPosition _initialPosition = MapPosition.fromGeopointZoom(s, 11);
    //MapPosition _initialPosition = MapPosition.fromDegZoom(52.45657243868931, 5.52041338863477, 11);
//    _mapView.SetMapPosition(_initialPosition);

//    DefaultMarkerRenderer defaultMarkerRenderer = new DefaultMarkerRenderer();
//    defaultMarkerRenderer.markerType = DefaultMarkerType.Red;
//    DefaultMarker marker2 = new DefaultMarker(defaultMarkerRenderer, new Size(35,50), t);
//    marker2.Name = "Marker2";
//    makersLayer.AddMarker(marker2);
//
//    GeoPoint harderwijk = e;
//    Timer(Duration(seconds: 5), (() {
//      marker2.Location = harderwijk;
//    }));

  }

  void _markerUpdated(MarkerBase marker) {
    _mapView.UpdateMap();
  }

  Widget _createOsmMapWidget() {
    return OsmMap(
        mapPosition: new MapPosition.Create(
          geoPoint: new GeoPoint(52.45657243868931, 5.52041338863477),
          zoomLevel: 11,
        ),
        mapReady: _mapReady,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(
        child: _osmMap,
//        child: _mapView
//        child: OsmMap(
//          mapPosition: new MapPosition.Create(
//            geoPoint: new GeoPoint(52.45657243868931, 5.52041338863477),
//            scale: 11,
//          )
//        ),
      )
    );
  }
}

// https://www.openstreetmap.org/export#map=11/52.4476/5.5206
// https://b.tile.openstreetmap.org/11/1053/673.png

//https://b.tile.openstreetmap.org/10/529/336.png