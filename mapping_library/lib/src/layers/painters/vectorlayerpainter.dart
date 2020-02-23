import 'dart:ui';
import 'package:flutter/widgets.dart';
import '../../objects/vector/geombase.dart';
import '../vectorlayer.dart';
import 'layerpainterbase.dart';

class VectorLayerPainter extends LayerPainterBase {

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    VectorLayer vectorLayer = layer as VectorLayer;

    for (GeomBase vector in vectorLayer.vectors) {
      if (vector.withinViewport(vectorLayer.mapViewPort)) {
        vector.paint(canvas);
      }
    }
  }
}