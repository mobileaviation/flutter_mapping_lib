import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/core/mapviewport.dart';
import 'layer.dart';

class Layers extends Stack {
  Layers({Key key, List<Widget> children})
      :super(key: key, children: children) {
  }

  MapViewport _mapViewport;
  get mapViewPort { return _mapViewport; }
  set mapViewPort(value) {
    _mapViewport = value;
  }

  notifyChildren(bool mapChanged) {
    for (Layer layer in children) {
      layer.layerUpdated = _updatedLayer;
      layer.notifyLayer(_mapViewport, mapChanged);
    }
  }

  Function(Layer layerUpdated) _updatedLayer;
  set updatedLayer(value) { _updatedLayer = value; }
}