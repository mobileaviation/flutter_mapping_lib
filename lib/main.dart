import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mapping_library/src/test/layer.dart';
import 'package:mapping_library/src/test/layers.dart';
import 'package:mapping_library/src/utils/mapposition.dart';
import 'package:mapping_library/src/utils/geopoint.dart';
import 'package:mapping_library/src/test/mapview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp() : super() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Container(
            child: Mapview(
                layers: Layers(
          mapPosition: MapPosition.create(
            // This is a location in the middle of the netherlands
            geoPoint: new GeoPoint(52.45657243868931, 5.52041338863477),
            zoomLevel: 10,
          ),
          children: <Widget>[
            TileLayer(
              backgroundColor: Colors.cyanAccent,
            ),
          ],
        ))));
  }
}

// https://www.openstreetmap.org/export#map=11/52.4476/5.5206
// https://b.tile.openstreetmap.org/11/1053/673.png

//https://b.tile.openstreetmap.org/10/529/336.png
