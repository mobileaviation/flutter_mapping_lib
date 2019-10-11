import 'dart:developer';
import 'package:flutter/widgets.dart';
import '../utils/geopoint.dart';
import '../utils/mapposition.dart';
import '../layers/layer.dart';
import '../layers/layerpainter.dart';
import 'mapviewgestures.dart';
import 'viewport.dart' as mapViewport;

class MapView extends StatefulWidget {
  MapView(this.mapReady) {
    this._createLayerPainter();
    this._mapCenterPosition = MapPosition.fromDegZoom(0, 0, 5);
  }

  MapView.fromMapPosition(this.mapReady, MapPosition mapPosition) {
    this._createLayerPainter();
    this._mapCenterPosition = mapPosition;
  }

  MapView.Create(Key key, this.mapReady, MapPosition mapPosition) : super(key: key){
    this._createLayerPainter();
    this._mapCenterPosition = mapPosition;
  }

  final void Function(MapView) mapReady;
  bool initialized = false;

  void Function(GeoPoint) mapClicked;

  void Function(mapViewport.Viewport viewport) mapPositionChanged;

  _createLayerPainter() {
    layerPainter = new LayerPainter();
  }

  setupViewPort(Size size) {
    _widgetSize = size;
    if (viewport == null) {
      viewport = new mapViewport.Viewport(_widgetSize, _mapCenterPosition);
    }
    viewport.SetMapPositionSize(_widgetSize, _mapCenterPosition);
  }

  @override
  MapViewGestures createState() => MapViewGestures();

  LayerPainter layerPainter;
  MapPosition _mapCenterPosition;
  Size _widgetSize;
  mapViewport.Viewport viewport;
  int zoomMin = 4;
  int zoomMax = 20;

  void SetMapPosition(MapPosition mapPosition) {
    if (mapPosition.getZoom()<zoomMin.toDouble() - 0.9) mapPosition.setZoom(zoomMin.toDouble() - 0.9);
    if (mapPosition.getZoom()>zoomMax.toDouble() + 0.9) mapPosition.setZoom(zoomMax.toDouble() + 0.9);
    if (initialized) {
      _mapCenterPosition = mapPosition;
      setupViewPort(_widgetSize);
      _notifyLayers();
      if (mapPositionChanged != null) {
        mapPositionChanged(viewport);
      }
    }
    else
      throw new Exception("Map is not initialized yet. Use 'mapReady' for further processing.");
  }

  void UpdateMap() {
    _notifyLayers();
  }

  MapPosition GetMapPosition() {
    return _mapCenterPosition;
  }

  void AddLayer(Layer layer) {
    if (initialized) {
      layerPainter.AddLayer(layer);
      layerPainter.notifyLayers(_mapCenterPosition, viewport);
      log("MapView: AddLayer");
    }
    else
      throw new Exception("Map is not initialized yet. Use 'mapReady' for further processing.");
  }

  void _notifyLayers() {
    if (initialized)
      layerPainter.notifyLayers(_mapCenterPosition, viewport);
    else
      throw new Exception("Map is not initialized yet. Use 'mapReady' for further processing.");
  }
}
