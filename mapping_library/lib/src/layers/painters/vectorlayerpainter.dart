import 'dart:ui';
import 'package:flutter/widgets.dart';
import '../../objects/vector/geombase.dart';
import '../vectorlayer.dart';
import 'layerpainterbase.dart';
import 'package:mapping_library/src/utils/mercatorprojection.dart' as MercatorProjection;

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