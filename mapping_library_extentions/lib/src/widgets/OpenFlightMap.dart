import 'package:flutter/widgets.dart';
import '../tiles/sources/openflightmapsource.dart';
import 'package:mapping_library/mapping_library.dart';

class OpenFlightMap extends StatelessWidget {
  OpenFlightMap({Key key, MapPosition mapPosition, this.mapReady})
      : super(key: key) {
    _mapPosition = mapPosition;
    _mapView = MapView.fromMapPosition(_mapReady, mapPosition);
    _mapView.mapClicked = _mapClicked;
    _mapView.mapPositionChanged = _mapPositionChanged;
    _mapView.zoomMax = 11;
    _mapView.zoomMin = 7;
  }

  MapView _mapView;
  final _openFlightMapsUrl =
      "https://snapshots.openflightmaps.org/live/##AIRAC##/tiles/world/noninteractive/epsg3857/merged/256/latest/##Z##/##X##/##Y##.png";

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
    OpenFlightMapsTileSource ofmTileSource =
        OpenFlightMapsTileSource(_openFlightMapsUrl, 'openflightmaps');
    ofmTileSource.openCachedTileSource(() {
      TilesLayer tileLayer = TilesLayer(ofmTileSource);
      _mapView.addLayer(tileLayer);

      if (mapReady != null) mapReady(mapView);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _mapView;
  }
}
