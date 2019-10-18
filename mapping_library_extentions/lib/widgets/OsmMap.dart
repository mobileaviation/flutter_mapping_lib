import 'package:flutter/widgets.dart';
import 'package:mapping_library/utils/geopoint.dart';
import 'package:mapping_library/core/mapview.dart';
import 'package:mapping_library/utils/mapposition.dart';
import 'package:mapping_library/layers/tilelayer.dart';
import '../tiles/sources/cachedhttpsource.dart';
import 'package:mapping_library/core/viewport.dart' as mapViewport;

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
    _createTileLayer(mapView);
    _mapView.SetMapPosition(_mapPosition);
  }

  void _createTileLayer(MapView mapView) {
    CachedHttpTileSource osmTileSource = new CachedHttpTileSource(_osmUrl, 'openflightmaps');
    osmTileSource.OpenCachedTileSource(() {
      TileLayer tileLayer = new TileLayer(osmTileSource);
      _mapView.AddLayer(tileLayer);

      if (mapReady != null) mapReady(mapView);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _mapView;
  }
}
