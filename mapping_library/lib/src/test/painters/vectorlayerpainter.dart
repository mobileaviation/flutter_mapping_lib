import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/core/values.dart' as values;
import 'package:mapping_library/src/layers/vector/geombase.dart';
import 'package:mapping_library/src/test/vectorlayer.dart';
import 'layerpainter.dart';
import 'package:mapping_library/src/utils/mercatorprojection.dart' as MercatorProjection;

class VectorLayerPainter extends LayerPainter {

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

  @override
  void redraw() {
    super.redraw();
  }
}