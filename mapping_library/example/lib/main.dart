import 'package:example/test_mbtiles.dart';
import 'package:example/test_overlay.dart';
import 'package:example/test_vectors.dart';
import 'package:flutter/material.dart';
import 'package:mapping_library_extentions/widgets/OpenFlightMap.dart';
import 'package:mapping_library/utils/mapposition.dart';
import 'package:mapping_library/utils/geopoint.dart';
import 'package:mapping_library/core/mapview.dart';
import 'package:mapping_library/layers/vectorlayer.dart';
import 'package:mapping_library/layers/Vector/geombase.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Mapping Library Test App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {
    _openFlightMap = _createOfmMapWidget();
  }
  OpenFlightMap _openFlightMap;
  PermissionStatus _storagePermStatus;

  Widget _createOfmMapWidget() {
    return OpenFlightMap(
      mapPosition: new MapPosition.Create(
        geoPoint: new GeoPoint(52.45657243868931, 5.52041338863477),
        zoomLevel: 10,
      ),
      mapReady: _mapReady,
    );
  }

  void _mapReady(MapView mapView) {
    _checkStorageAccess().then((permission){
      if (permission.value == 2) {
        // Permission for storage access is granded so display both the overlay
        // and mbtiles file.
        SetupTestOverlay(mapView);
      }

      VectorLayer vectorLayer = new VectorLayer();
      mapView.AddLayer(vectorLayer);
      vectorLayer.VectorSelected = _vectorSelected;

      TestPolyLineUpdate(vectorLayer);
    });

    SetupTestMBTilesSource(mapView);
  }

  void _vectorSelected(GeomBase vector, GeoPoint clickedPosition) {
    log("Vector selected: " + vector.Name);
  }

  Future<PermissionStatus> _checkStorageAccess() async {
    _storagePermStatus = await _checkStoragePermissionStatus();
    if (_storagePermStatus.value == 2) return _storagePermStatus;

    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    _storagePermStatus = await _checkStoragePermissionStatus();
    return _storagePermStatus;
  }

  Future<PermissionStatus> _checkStoragePermissionStatus() async {
    return await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: _openFlightMap,
          color: Colors.greenAccent,
        ),
      ),
    );
  }
}
