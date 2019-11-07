import 'package:example/test_markers.dart';
import 'package:example/test_overlay.dart';
import 'package:example/test_vectors.dart';
import 'package:flutter/material.dart';
import 'package:mapping_library/mapping_library.dart';
import 'package:mapping_library_extentions/extentions.dart';
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
  }

  @override
  initState() {
    super.initState();
    storagePermissionGranded = false;
  }

  bool storagePermissionGranded;

  // Some operations needs permission from the user to run
  PermissionStatus _storagePermStatus;

  /// Do a security check to see if access to localstorage is granded
  /// This is probably only necessary for Android devices
  Future<PermissionStatus> _checkStorageAccess() async {
    _storagePermStatus = await _checkStoragePermissionStatus();
    if (_storagePermStatus.value == 2) return _storagePermStatus;
    // If storage access is NOT granded ask for permission from the user..
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    _storagePermStatus = await _checkStoragePermissionStatus();
    return _storagePermStatus;
  }

  Future<PermissionStatus> _checkStoragePermissionStatus() async {
    return await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  }

  @override
  Widget build(BuildContext context) {
    return _checkStoragePermissions();
  }

  Widget _checkStoragePermissions()
  {
    if (storagePermissionGranded) {
      return _retrieveMapContainer();
    } else {
      // We do a check to see, or ask for storage access permissions ( probably
      // only applicable for andriod devices)
      _checkStorageAccess().then((permission) {
        // permission.value=2 : granted
        if (permission.value == 2) {
          // Permission for storage access is granded so display the mapview
          setState(() {
            storagePermissionGranded = true;
          });
        }
      });
      return _retrievePermissionCheckContainer();
    }
  }

  Widget _retrievePermissionCheckContainer() {
    return Center(
      child: Container(
        child: Text("Retrieving storage permissions..."),
      ),
    );
  }

  Widget _retrieveMapContainer() {
    return Container(
        child: Mapview(
            mapPosition: MapPosition.create(
              // This is a location in the middle of the netherlands
              geoPoint: new GeoPoint(52.45657243868931, 5.52041338863477),
              zoomLevel: 10,
            ),
            layers: Layers(
              children: <Widget>[
                TilesLayer(
                  //tileSource: HttpTileSource("http://c.tile.openstreetmap.org/##Z##/##X##/##Y##.png"),

                  tileSource: HttpTileSource("https://snapshots.openflightmaps.org/live/1912/tiles/world/noninteractive/epsg3857/merged/256/latest/##Z##/##X##/##Y##.png"),
                  //https://snapshots.openflightmaps.org/live/1912/tiles/world/noninteractive/epsg3857/merged/512/latest/8/131/83.png
                  name: "Tiles Layer",
                ),
                OverlayLayer(
                  overlayImages: getOverlayImages(OverlayImages()),
                  name: "Overlay Layer",
                ),
                FixedObjectLayer(
                  fixedObject: ScaleBar(FixedObjectPosition.lefttop,
                      Offset(10,10)),
                  name: "FixedObject Layer",
                ),
                MarkersLayer(
                  markers: getMarkers(Markers()),
                  name: "Markers Layer",
                  markerSelected: _markerSelected,
                ),
                VectorLayer(
                  vectors: getVectors(Vectors()),
                  name: "Vectors Layer",
                  vectorSelected: _vectorSelected,
                )
              ],
            )
        )
    );
  }

  void _vectorSelected(GeomBase vector, GeoPoint clickedPosition) {
    log("Vector selected: ${vector.name}");
  }

  void _markerSelected(MarkerBase marker){
    log("Marker selected: ${marker.name}");
  }
}
