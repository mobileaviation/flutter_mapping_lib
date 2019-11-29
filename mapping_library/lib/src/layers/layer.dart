import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/core/mapviewport.dart';
import 'package:mapping_library/src/layers/painters/layerpainter.dart';
import 'package:geometric_utils/geometric_utils.dart';
import 'painters/layerpainterbase.dart';
import 'painters/testlayerpainter.dart';

class TestLayer extends Layer {
  TestLayer({Key key, Color backgroundColor,
      Size backgroundSize,
      Offset backgroundOffset,
      String name})// : super(key)
  {
    layerPainter = TestLayerPainter();
    layerPainter.layer = this;
    bgColor = backgroundColor;
    bgSize = backgroundSize;
    bgPosition = backgroundOffset;
    _name = (name == null) ? "TestLayer" : name;
  }

  get _layerPainter {
    return (layerPainter as TestLayerPainter);
  }

  set bgColor(value) {
    _layerPainter.backgroundColor = value;
  }
  set bgSize(value) {
    _layerPainter.blockSize = value;
  }
  set bgPosition(value) {
    _layerPainter.blockPosition = value;
  }

  @override
  notifyLayer(MapViewport viewport, bool mapChanged) {
    super.notifyLayer(viewport, mapChanged);
  }
}

class Layer {
  LayerPainterBase layerPainter;
  LayerPainter painter;

  String _name;
  set name(value) {_name = value; }
  String get name => _name;

  MapViewport _mapViewport;
  MapViewport get mapViewPort => _mapViewport;
  set mapViewPort(value) {
    _mapViewport = value;
  }

  set layerUpdated(value) { _layerUpdated = value; }
  Function(Layer layer) get layerUpdated => _layerUpdated;
  Function(Layer layer) _layerUpdated;

  redrawPainter() {
    if (painter != null)
      painter.redraw();
  }

  notifyLayer(MapViewport viewport, bool mapChanged) {
    _mapViewport = viewport;
  }

  void doTabCheck(GeoPoint clickedPosition, Offset screenPos) {}

  void dragStart(GeoPoint clickedPosition, Offset screenPos) {}

  void drag(GeoPoint clickedPosition, Offset screenPos) {}

  void dragEnd(GeoPoint clickedPosition, Offset screenPos) {}
}
