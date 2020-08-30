import 'package:example/test_markers.dart';
import 'package:example/test_overlay.dart';
import 'package:example/test_vectors.dart';
import 'package:flutter/material.dart';
import 'package:mapping_library/mapping_library.dart';
import 'package:geometric_utils/geometric_utils.dart';
import 'package:mapping_library/src/objects/vector/markergeopoint.dart';
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
      home: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            child: MappingHomePage(
              title: 'Mapping Library Test App',
            ),
          ),

          // Center(
          //   child: Text(
          //     'Dit is een test',
          //     style: TextStyle(
          //       fontSize: 100,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.white,
          //     ),
          //   ),
          // )
          Container(),
        ]
      )
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
        )
    );
  }
              
  void _vectorSelected(GeomBase vector, GeoPoint clickedPosition) {
    log("Vector selected: ${vector.name}");
  }

  void _markerSelected(MarkerBase marker){
    log("Marker selected: ${marker.name}");
  }

  _dragVectorStart(GeomBase vector, MarkerGeopoint marker_point, GeoPoint startPosition) {
    log("Start Drag Vector: ${vector.name} at ${startPosition.toString()}");
  }

  _dragVectorEnd(GeomBase vector, MarkerGeopoint marker_point, GeoPoint endPosition) {
    log("End Drag Vector: ${vector.name} at ${endPosition.toString()}");
  }
}
