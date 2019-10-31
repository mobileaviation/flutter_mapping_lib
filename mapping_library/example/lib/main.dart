import 'package:example/test_fixedobjects.dart';
import 'package:example/test_markers.dart';
import 'package:example/test_mbtiles.dart';
import 'package:example/test_overlay.dart';
import 'package:example/test_vectors.dart';
import 'package:flutter/material.dart';
import 'package:mapping_library_extentions/extentions.dart';
import 'package:mapping_library/mapping_library.dart';
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
      home: MappingHomePage(title: 'Mapping Library Test App'),
    );
  }
}

class MappingHomePage extends StatefulWidget {
  MappingHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MappingPageState createState() => _MappingPageState();
}

/// This is an example of how to use the mapping_library
///
/// The mapping tiles used in this example are from
/// the https://www.openflightmaps.org website
///
/// This example will show tiles from the openflightmaps site
/// To run this example copy the files which are in the example/files
/// directory to your device in the /sdcard/Download directory
class _MappingPageState extends State<MappingHomePage> {
  _MappingPageState() {
    _openFlightMap = _createOfmMapWidget();
  }
  // This is the base Widget which will show just the map tiles
  // from openflightmaps
  OpenFlightMap _openFlightMap;
  // Some operations needs permission from the user to run
  PermissionStatus _storagePermStatus;

  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // !!!!!!!!!!!!!!!!!! Important !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // The widget needs to be pre-created in the constructor of the parent
  // widget. It will not work correctly if you create the widget in the
  // build function
  // _createOfmMapWidget needs to be called from the parents oonstructor
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  Widget _createOfmMapWidget() {
    return OpenFlightMap(
      mapPosition: new MapPosition.create(
        // This is a location in the middle of the netherlands
        geoPoint: new GeoPoint(52.45657243868931, 5.52041338863477),
        zoomLevel: 10,
      ),
      mapReady: _mapReady,
    );
  }

  // mapReady Callback
  //
  // This callback is mandatory. Anything that you want to add to the map in
  // terms of layers, markers etc. can only be added after this callback
  void _mapReady(MapView mapView) {
    // We so a check to see, or ask for storage access permissions ( probably
    // only applicable for andriod devices)
    _checkStorageAccess().then((permission){
      // permission.value=2 : granted
      if (permission.value == 2) {
        // Permission for storage access is granded so display both the overlay
        // and mbtiles file.
        // Check the test_overlay.dart for the implementation
        setupTestOverlay(mapView);
        // This function will add a additional layer. The first layer is already
        // added when the Widget was created. This will be the base layer. All
        // newly added layers are drawn on top of the base tile layer in order
        // in which the layers are added.
      }

      // A vector layer is used to add "vector" type objects like lines, circles
      // polylines or (closed) polygons. You may use more than one vector layer
      // to have more control over the order the objects are drawn
      VectorLayer vectorLayer = VectorLayer();
      mapView.addLayer(vectorLayer);
      // Polygons and Lines currently support the selected event
      vectorLayer.vectorSelected = _vectorSelected;

      // A marker layer is used to add "Markers" to the map
      MarkersLayer markersLayer = MarkersLayer();
      mapView.addLayer(markersLayer);
      markersLayer.markerSelected = _markerSelected;

      // Checkout the following methods for there implementation
      testPolyLineUpdate(vectorLayer, mapView);  // see test_vectors.dart
      drawHoogeveenCircuit(vectorLayer);  // see test_vectors.dart
      drawLelystadCircuit(vectorLayer); // see test_vetors.dart
      drawSchipholCtr(vectorLayer); // see test_vectors.dart

      // Checkout the following methods for adding Markers to the map
      addDefaultMarker(markersLayer); // see test_markers.dart
      addSimpleMarker(markersLayer); // see test_markers.dart
      addImageMarker(markersLayer); // see test_markers.dart

      addTestFixedObject(mapView);
    });

    // This method will add a "mbtiles" rastermap file to the map
    // see test_mbtiles.dart
    setupTestMBTilesSource(mapView);
  }

  void _vectorSelected(GeomBase vector, GeoPoint clickedPosition) {
    log("Vector selected: " + vector.name);
  }

  void _markerSelected(MarkerBase marker) {
    log("Marker selected: ${marker.name} Selected: ${marker.selected}");
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
          // Give the container a size to fill its parent. The mapview will
          // always (current implementation) full extent to its parent
          height: double.infinity,
          width: double.infinity,
          child: _openFlightMap,
          color: Colors.greenAccent,
        ),
      ),
    );
  }
}
