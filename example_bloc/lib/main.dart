import 'package:flutter/material.dart';
import 'package:mapping_library_bloc/mapping_library_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key) {
    String _url = "https://tile.openstreetmap.org/##Z##/##X##/##Y##.png";
    _tileSource = HttpTileSource(_url);
    _baseTilesLayer = TileLayer(_tileSource);
    _layers.add(_baseTilesLayer);
  }

  TileLayer _baseTilesLayer;
  final Layers _layers = Layers();
  HttpTileSource _tileSource;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child:  Container(
          child: MapView(
            layers : widget._layers,
            centerLocation: MapPosition.fromGeopointZoom(GeoPoint(52.45657243868931, 5.52041338863477),10),
          ),
        )
      ),
    );
  }
}
