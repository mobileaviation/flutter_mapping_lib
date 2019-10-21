import 'package:flutter/widgets.dart';
import 'package:mapping_library/mapping_library.dart';
import '../tiles/sources/cachedhttpsource.dart';

class OsmMap extends StatelessWidget {
  OsmMap({Key key, MapPosition mapPosition, this.mapReady}) : super(key: key) {
    _mapPosition = mapPosition;
    _mapView = new MapView.fromMapPosition(_mapReady, mapPosition);
    _mapView.mapClicked = _mapClicked;
    _mapView.mapPositionChanged = _mapPositionChanged;
  }

  MapView _mapView;
  final _osmUrl = "http://c.tile.openstreetmap.org/##Z##/##X##/##Y##.png";

  Function(MapView mapView) mapReady;
  Function(MapViewport viewport) mapPositionChanged;
  Function(GeoPoint tabbedPoint) mapTabbed;

  MapPosition _mapPosition;

  void _mapClicked(GeoPoint clickedPoint) {
    if (mapTabbed != null) {
      mapTabbed(clickedPoint);
    }
  }

  void _mapPositionChanged(MapViewport viewport) {
    if (mapPositionChanged != null) {
      mapPositionChanged(viewport);
    }
  }

  void _mapReady(MapView mapView) {
    _createTileLayer(mapView);
    _mapView.setMapPosition(_mapPosition);
  }

  void _createTileLayer(MapView mapView) {
    CachedHttpTileSource osmTileSource = new CachedHttpTileSource(_osmUrl, 'openflightmaps');
    osmTileSource.openCachedTileSource(() {
      TilesLayer tileLayer = new TilesLayer(osmTileSource);
      _mapView.addLayer(tileLayer);

      if (mapReady != null) mapReady(mapView);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _mapView;
  }
}
