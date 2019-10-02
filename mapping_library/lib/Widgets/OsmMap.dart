import 'package:flutter/widgets.dart';
import 'package:mapping_library/utils/geopoint.dart';
import '../core/mapview.dart';
import '../utils/mapposition.dart';
import '../layers/tilelayer.dart';
import '../tiles/httptilesource.dart';
import '../core/viewport.dart' as mapViewport;

class OsmMap extends StatelessWidget {
  OsmMap({Key key, MapPosition mapPosition}) : super(key: key) {
    _mapPosition = mapPosition;
    _mapView = new MapView.fromMapPosition(_mapReady, mapPosition);
    _mapView.mapClicked = _mapClicked;
    _mapView.mapPositionChanged = _mapPositionChanged;

  }

  MapView _mapView;
  final _osmUrl = "http://c.tile.openstreetmap.org/##Z##/##X##/##Y##.png";

  Function(MapView mapView) mapReady;
  Function(mapViewport.Viewport viewport) mapPositionChanged;
  Function(GeoPoint tabbedPoint) mapTabbed;

  MapPosition _mapPosition;

  void _mapClicked(GeoPoint clickedPoint) {
    if (mapTabbed != null) {
      mapTabbed(clickedPoint);
    }
  }

  void _mapPositionChanged(mapViewport.Viewport viewport) {
    if (mapPositionChanged != null) {
      mapPositionChanged(viewport);
    }
  }

  void _mapReady(MapView mapView) {
    _createTileLayer();
    _mapView.SetMapPosition(_mapPosition);

    if (mapReady != null) {
      mapReady(mapView);
    }
  }

  void _createTileLayer() {
    HttpTileSource osmTileSource = new HttpTileSource(_osmUrl);
    TileLayer tileLayer = new TileLayer(osmTileSource);
    _mapView.AddLayer(tileLayer);
  }

  @override
  Widget build(BuildContext context) {
    return _mapView;
  }
}
