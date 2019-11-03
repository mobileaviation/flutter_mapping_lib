import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/core/mapviewport.dart';
import 'package:mapping_library/src/utils/mapposition.dart';
import 'package:mapping_library/src/test/layer.dart';

class Layers extends Stack {
  Layers({Key key, List<Widget> children, MapPosition mapPosition})
      :super(key: key, children: children) {
    _mapPosition = mapPosition;
  }

  MapPosition _mapPosition;
  get mapPosition { return _mapPosition; }
  set mapPosition(value) {
    _mapPosition = value;
    _notifyChildren();
  }

  MapViewport _mapViewport;
  get mapViewPort { return _mapViewport; }
  set mapViewPort(value) {
    _mapViewport = value;
    _notifyChildren();
  }

  _notifyChildren() {
    for (Layer layer in children) {
      layer.layerUpdated = _layerUpdated;
      layer.notifyLayer(_mapPosition, _mapViewport);
    }
  }

  void _layerUpdated(Layer updatedLayer) {
    if (_updatedLayer != null) _updatedLayer(updatedLayer);
  }

  Function(Layer layerUpdated) _updatedLayer;
  set updatedLayer(value) { _updatedLayer = value; }
}