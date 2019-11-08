import 'dart:ui';
import 'package:flutter/widgets.dart';
import '../fixedobjectlayer.dart';
import 'layerpainterbase.dart';

class FixedObjectLayerPainter extends LayerPainterBase {

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    FixedObjectLayer fixedObjectLayer = layer as FixedObjectLayer;
    fixedObjectLayer.fixedObject.paint(canvas);
  }
}