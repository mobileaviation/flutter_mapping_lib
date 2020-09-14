import 'package:flutter/widgets.dart';
import 'package:mapping_library/mapping_library.dart';
import '../core/mapviewport.dart';
import '../layers/painters/layerpainter.dart';
import 'layer.dart';

class Layers extends Container {
  Layers({Key key, List<Layer> layers})
      :super(key:key, child: CustomPaint(
        painter: LayerPainter(),
  )) {
    this.layers = layers;
    _painter = (child as CustomPaint).painter;
    _painter.layers = this;
  }

  LayerPainter _painter;

  List<Layer> _layers;
  set layers(List<Layer> values) { _layers = values; }
  List<Layer> get layers => _layers;

  Size _size;
  set size (Size size) {
    _changeSize(size);
  }
  Size get size => _size;

  MapViewport _mapViewport;
  MapViewport get mapViewPort => _mapViewport;
  set mapViewPort(MapViewport value) {
    _mapViewport = value;
  }

  notifyLayers(bool mapChanged) {
    for (Layer l in layers) {
      l.layerUpdated = _updatedLayer;
      l.notifyLayer(_mapViewport, mapChanged);
    }
  }

  void _changeSize(Size size) {
    if (_size == null) _setSize(size);
    if ((size.width != _size.width) || (size.height != _size.height))
      _setSize(size);
  }

  void _setSize(Size size) {
    _size = size;
    notifyLayers(true);
  }

  Function(Layer layerUpdated) _updatedLayer;
  set updatedLayer(value) { _updatedLayer = value; }
}