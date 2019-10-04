import 'package:flutter/widgets.dart';
import '../tiles/sources/openflightmapsource.dart';
import '../utils/geopoint.dart';
import '../core/mapview.dart';
import '../utils/mapposition.dart';
import '../layers/tilelayer.dart';
import '../core/viewport.dart' as mapViewport;

class OpenFlightMap extends StatelessWidget {
  OpenFlightMap({Key key, MapPosition mapPosition, this.mapReady}) : super(key: key) {
    _mapPosition = mapPosition;
    _mapView = new MapView.fromMapPosition(_mapReady, mapPosition);
    _mapView.mapClicked = _mapClicked;
    _mapView.mapPositionChanged = _mapPositionChanged;
  }

  MapView _mapView;
  final _openFlightMapsUrl = "https://snapshots.openflightmaps.org/live/##AIRAC##/tiles/world/noninteractive/epsg3857/merged/256/latest/##Z##/##X##/##Y##.png";

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
    OpenFlightMapsTileSource ofmTileSource = new OpenFlightMapsTileSource(_openFlightMapsUrl);
    TileLayer tileLayer = new TileLayer(ofmTileSource);
    _mapView.AddLayer(tileLayer);
  }

  @override
  Widget build(BuildContext context) {
    return _mapView;
  }
}

