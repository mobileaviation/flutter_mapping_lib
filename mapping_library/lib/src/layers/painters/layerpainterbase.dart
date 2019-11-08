import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/core/mapviewport.dart';
import '../layer.dart';
import '../layers.dart';

class LayerPainterBase {
  Layer layer;
  Layers layers;

  void paint(Canvas canvas, Size size) {
  }

  void redraw() {}

  bool _doRedraw = true;
  bool get doRedraw => _doRedraw;
  set doRedraw(bool value) { _doRedraw = value; }

  Picture _layerPicture;
  Picture get layerPicture => _layerPicture;
  set layerPicture(Picture value) { _layerPicture = value; }
}