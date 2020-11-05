import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvt_tiles/mvt_tiles.dart' as mvt;
import 'map_painter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
  final String styleName = 'maptiler_basic';

  Future<Uint8List> loadMvtTile(String filename, BuildContext context) async {
    ByteData data = await DefaultAssetBundle.of(context).load(filename);
    return Uint8List.sublistView(data);
  }

  @override
  initState() {
    super.initState();
    loadMBTilesFile().then((value) {
      log("Loaded ${value}");
      openDatabase(value, readOnly: false).then((value) async
      {
        log("database opened");
        styles = await mvt.loadStyles(styleName);
        log("Styles ${styleName} loaded");
        List<Map> tiles = await value.rawQuery('SELECT * FROM images WHERE tile_id=?', ['8/131/171']);
        if (tiles.length>0) {
          if (tiles[0]['tile_data'] is Uint8List) log("Found image tile blob");
          Uint8List tile = tiles[0]['tile_data'];
          Uint8List unzippedTileData = GZipCodec().decode(tile);
          testTile(this.context, unzippedTileData);
        }
      });
      
    });
  }

  mvt.VectorTile tile;
  mvt.Styles styles;
  int _updateCount = 0;

  Future<String> loadMBTilesFile() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "2017-07-03_netherlands_amsterdam.mbtiles");
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch(_) {
      print("Error creating directory ${path}");
    }
    ByteData data = await rootBundle.load(join("tiles", "2017-07-03_netherlands_amsterdam.mbtiles"));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);

    return path;
  }

  void testTile(BuildContext context, Uint8List dbTile) async {
    Uint8List value = dbTile;
    log("Tile loaded: ${value.length}", time: DateTime.now());
    tile = mvt.VectorTile(dbTile);
    log("Start rendering tile: ", time: DateTime.now());
    tile.renderTile(styles).then((value) {
      this.setState(() {
        log("Tile rendered, setState to update painter", time: DateTime.now());
        _updateCount++;
      });
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
