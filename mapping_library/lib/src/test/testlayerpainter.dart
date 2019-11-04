import 'dart:ui';
import 'package:mapping_library/src/test/layerpainter.dart';
import 'layer.dart';

class TestLayerPainter extends LayerPainter {

  Color backgroundColor;
  Size blockSize;
  Offset blockPosition;

  paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    Paint paint = Paint()
      ..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(
        blockPosition.dx,
        blockPosition.dy,
        blockSize.width,
        blockSize.height), paint);
  }
}