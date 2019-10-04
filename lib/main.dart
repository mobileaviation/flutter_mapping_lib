import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mapping_library/layers/markerslayer.dart';
import 'package:mapping_library/layers/tilelayer.dart';
import 'package:mapping_library/layers/vectorlayer.dart';
import 'package:mapping_library/tiles/sources/httptilesource.dart';
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
import 'package:mapping_library/layers/Vector/polygon.dart';
import 'package:mapping_library/Widgets/OsmMap.dart';
import 'package:mapping_library/Widgets/OpenFlightMap.dart';
import 'package:mapping_library/utils/mapposition.dart' as prefix1;
import 'package:mapping_library/Widgets/utils/airac.dart';
import 'package:mapping_library/utils/geopoints.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp() : super() {
    _mapView = new mapview.MapView(_mapReady);
    _osmMap = _createOsmMapWidget();
    _ofmMap = _createOfmMapWidget();
  }

  mapview.MapView _mapView;
  OsmMap _osmMap;
  OpenFlightMap _ofmMap;

  _mapReady(mapview.MapView mapView) {
    GeoPoint s = new GeoPoint(52.45657243868931, 5.52041338863477);
    GeoPoint t = new GeoPoint(52.383063, 5.556776);
    GeoPoint e = new GeoPoint(52.349690, 5.634789);
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
    Line line = new Line(s, e);
    Circle circle = new Circle(t, 1000);

    VectorLayer vectorLayer = new VectorLayer();
    vectorLayer.AddVectors(line);
    vectorLayer.AddVectors(circle);
    //mapView.AddLayer(vectorLayer);


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

    String trafficCircuitEHHO = "6.52509200013541,52.7306369999699 6.52536837932791,52.7306259291328 6.52536837932791,52.7306259291328 6.54761711045751,52.7297329136902 6.55067567032722,52.7296095844004 6.55286584800144,52.7307703154414 6.55306938491788,52.7326225121997 6.55308228089967,52.7327409600383 6.55308228089967,52.7327409600383 6.55401875324438,52.7413696337004 6.55422271262167,52.7432247735352 6.55230690861631,52.7445506200243 6.54924252640154,52.744674971413 6.54858097798292,52.7447015852281 6.54858097798292,52.7447015852281 6.48819599186663,52.7471135049954 6.48513928131557,52.7472358827491 6.48294887327464,52.7460737854257 6.48274839225936,52.7442233901648 6.48273543954264,52.7441049321505 6.48273543954264,52.7441049321505 6.48178857164967,52.7354721133458 6.48158822523598,52.7336220554346 6.4835086916069,52.7322966701029 6.48656401156079,52.7321763196082 6.48678930604847,52.7321673575445 6.48678930604847,52.7321673575445 6.50909299981233,52.7312780000086";
    String trafficCircuitEHLE = "5.52458889125152,52.4587277800044 5.52484300122376,52.4588697791537 5.52484300122376,52.4588697791537 5.54633722695909,52.4708757305781 5.54832623653387,52.4719861738938 5.55154930110094,52.4719006434685 5.55337224570004,52.4706890423896 5.55352320408749,52.4705887939362 5.55352320408749,52.4705887939362 5.56509807329495,52.4629022054321 5.56692098087489,52.4616899250738 5.56677862836174,52.4597233868798 5.5647878156617,52.4586135658832 5.56418015742951,52.4582743515565 5.56418015742951,52.4582743515565 5.50773338212851,52.4267248611918 5.50574667251343,52.4256146779705 5.50252939869441,52.4256997528863 5.50070774734002,52.4269106412474 5.50055697047508,52.4270109291608 5.50055697047508,52.4270109291608 5.48898729553504,52.4347059744646 5.48716516802067,52.4359164763822 5.48730196588175,52.4378771762641 5.48928630300586,52.4389889449381 5.48950357500167,52.4391105196022 5.48950357500167,52.4391105196022 5.51101944002569,52.4511444400002";
    GeoPoints points = new GeoPoints();
    points.addFromString(trafficCircuitEHLE);

    //VectorLayer vectorLayer = new VectorLayer();
    Polygon lelystadCircuit = new Polygon(points);
    lelystadCircuit.geomPaint.color = Colors.lightBlue;
    lelystadCircuit.geomPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, 2);
    vectorLayer.AddVectors(lelystadCircuit);
    mapView.AddLayer(vectorLayer);

    log ("Get polygon");
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

  Widget _createOfmMapWidget() {
    return OpenFlightMap(
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
        child: _ofmMap,
        //child: _osmMap,
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