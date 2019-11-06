import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:mapping_library/src/test/fixedobjectlayer.dart';
import 'layerpainter.dart';

class FixedObjectLayerPainter extends LayerPainter {

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    FixedObjectLayer fixedObjectLayer = layer as FixedObjectLayer;
    fixedObjectLayer.fixedObject.paint(canvas);
  }

  @override
  void redraw() {
    super.redraw();
  }
}