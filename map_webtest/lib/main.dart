import 'package:flutter/material.dart';
import 'package:mapping_library/mapping_library.dart';
import 'package:geometric_utils/geometric_utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mapping Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Mapview Test"),
        ),
        body: Container(
          color: Colors.green,
          constraints: BoxConstraints.expand(),
          child: Mapview(
            mapPosition: MapPosition.create(
                    // This is a location in the middle of the netherlands
                    geoPoint: new GeoPoint(52.45657243868931, 5.52041338863477),
                    zoomLevel: 10,
                  ),
            layers: Layers(
              layers: <Layer>[
                      TilesLayer(
                        tileSource: HttpTileSource("http://c.tile.openstreetmap.org/##Z##/##X##/##Y##.png"),
                        name: "TilesLayer",
                      )],
            ),
          ),
        ),
      ),
    );
  }
}
