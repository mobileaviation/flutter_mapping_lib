import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mapping_library/mapping_library.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geometric_utils/geometric_utils.dart';
import 'map_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp() {
  }

  Widget _map;

  @override
  Widget build(BuildContext context) {
    _map = MapWidget();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MappingHomePage(
              title: 'Mapping Library Test App',
              map: _map,
            ),
    );
  }
}

class MappingHomePage extends StatefulWidget {
  MappingHomePage({Key key, String title, MapWidget map}) : super(key: key) {
    this._title = title;
    this._map = map;
    
  }
  String _title;
  MapWidget _map;

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
    editWindowVisible = false;
    editWindowPosition = Offset(0,0);
  }

  bool storagePermissionGranded;

  // Some operations needs permission from the user to run
  PermissionStatus _storagePermStatus;


  bool editWindowVisible;
  Offset editWindowPosition;

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
    widget._map.vectorSelected = _vectorSelected;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        _checkStoragePermissions(),
        _getTestMapWindow(),
      ],
    );
  }

  Widget _checkStoragePermissions()
  {
    if (storagePermissionGranded) {
      return widget._map;
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

  MapWindow _getTestMapWindow() {
    return MapWindow(
      visible: editWindowVisible,
      position: editWindowPosition,
      children: [
        RaisedButton(
          onPressed: () {},
          child: Text('Enabled Button1', style: TextStyle(fontSize: 20)),
        ),
        RaisedButton(
          onPressed: () {},
          child: Text('Enabled Button2', style: TextStyle(fontSize: 20)),
        )
      ],
    );
  }  

  void _vectorSelected(GeomBase vector, GeoPoint clickedPosition, Offset screenPos) {
    log("Vector selected: ${vector.name}");
    if (vector is Polyline) log("Polyline Part selected index: ${(vector as Polyline).selectedIndex}");
    setState(() {
      editWindowVisible = true;
      editWindowPosition = screenPos;
    });
  }
}
