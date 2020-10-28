import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mvt_tiles/mvt_tiles.dart' as mvt;
import 'map_painter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vector Tiles Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Vector Tiles Test App'),
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

  Future<Uint8List> loadMvtTile(String filename, BuildContext context) async {
    ByteData data = await DefaultAssetBundle.of(context).load(filename);
    return Uint8List.sublistView(data);
  }

  @override
  initState() {
    super.initState();
    testTile(context);
  }

  mvt.Tile tile;
  mvt.Styles styles;


  void testTile(BuildContext context) async {
    //Uint8List value = await loadMvtTile('tiles/10-527-336.mvt', context);
    Uint8List value = await loadMvtTile('tiles/336.pbf', context);
    print ("Tile loaded: ${value.length}");
    styles = await mvt.loadStyles('osm-bright-gl-style');
    
    this.setState(() {
      tile = mvt.loadTile(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          child: CustomPaint(
              child: Container(),
              painter: MapPainter(
                tile: tile,
                styles: styles,
              ),
            ),
        )
    );
  }
}
