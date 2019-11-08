import 'dart:ui';
import 'package:flutter/widgets.dart';
import '../../objects/overlay/overlayimage.dart';
import '../overlaylayer.dart';
import 'layerpainterbase.dart';

class OverlayLayerPainter extends LayerPainterBase {

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