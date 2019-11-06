import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/core/values.dart' as values;
import 'package:mapping_library/src/layers/overlay/overlayimage.dart';
import 'package:mapping_library/src/test/overlaylayer.dart';
import 'layerpainter.dart';
import 'package:mapping_library/src/utils/mercatorprojection.dart' as MercatorProjection;

class OverlayLayerPainter extends LayerPainter {

  @override
  void paint(Canvas canvas, Size size) {
    OverlayLayer overlayLayer = layer as OverlayLayer;

    super.paint(canvas, size);
    for (OverlayImage image in overlayLayer.overlayImages) {
      if (image.withinViewport(overlayLayer.mapViewPort)) {
        image.paint(canvas);
      }
    }
  }

  @override
  void redraw() {
    super.redraw();
  }
}